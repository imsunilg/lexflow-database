using System.Text.RegularExpressions;
using Npgsql;

namespace LexFlow.Database.Runner;

/// <summary>
/// Assertion checks run by `--verify-only` against a throwaway database that already has
/// every script in Scripts/ applied. Each check returns a list of human-readable failure
/// strings (empty = passed).
/// </summary>
internal static class Verification
{
    /// <summary>
    /// Every column §14 requires on a "business table" (tenant_id, and the full
    /// created_at/created_by/updated_at/updated_by/is_deleted/deleted_at/deleted_by trio).
    /// </summary>
    public static readonly string[] RequiredColumns =
    [
        "tenant_id", "created_at", "created_by", "updated_at", "updated_by",
        "is_deleted", "deleted_at", "deleted_by"
    ];

    /// <summary>
    /// schema.table -> the subset of RequiredColumns that table is explicitly exempt from.
    /// Every entry here must be traceable to a real design decision already made and
    /// documented in that table's own migration file — this is not a place to silently
    /// paper over a missing column on a table that should have one.
    /// </summary>
    public static readonly IReadOnlyDictionary<string, HashSet<string>> AuditColumnWhitelist =
        new Dictionary<string, HashSet<string>>
        {
            // DB-2 (02_Core/Tenants): the tenant root itself. No tenant_id to filter tenants
            // by tenants; no created_by/updated_by/deleted_by because no user can exist
            // before the first tenant does.
            ["core.tenants"] = ["tenant_id", "created_by", "updated_by", "deleted_by"],

            // DB-15 (17_Reporting_StarSchema): shared calendar dimension — a date has no
            // tenant and no lifecycle.
            ["rpt.rpt_dim_date"] =
            [
                "tenant_id", "created_at", "created_by", "updated_at", "updated_by",
                "is_deleted", "deleted_at", "deleted_by"
            ],

            // DB-15: denormalized, ETL-populated star-schema dims/facts. Tenant-scoped, but
            // not directly user-edited, so only `updated_at` (set by the hourly job) — no
            // created_by/updated_by/is_deleted/deleted_at/deleted_by.
            ["rpt.rpt_dim_client"] = ["created_at", "created_by", "updated_by", "is_deleted", "deleted_at", "deleted_by"],
            ["rpt.rpt_dim_lawyer"] = ["created_at", "created_by", "updated_by", "is_deleted", "deleted_at", "deleted_by"],
            ["rpt.rpt_dim_practice_area"] = ["created_at", "created_by", "updated_by", "is_deleted", "deleted_at", "deleted_by"],
            ["rpt.rpt_fact_billing"] = ["created_at", "created_by", "updated_by", "is_deleted", "deleted_at", "deleted_by"],
            ["rpt.rpt_fact_time"] = ["created_at", "created_by", "updated_by", "is_deleted", "deleted_at", "deleted_by"],
            ["rpt.rpt_fact_matters"] = ["created_at", "created_by", "updated_by", "is_deleted", "deleted_at", "deleted_by"],

            // DB-10 (10_Audit/AuditEvents): the audit trail itself — `at` is its own creation
            // timestamp; there is no audit-of-the-audit-log.
            ["audit.audit_events"] =
            [
                "created_at", "created_by", "updated_at", "updated_by",
                "is_deleted", "deleted_at", "deleted_by"
            ],

            // DB-6 (06_Fin/RunningTimers): single-row-per-user live timer state, deleted
            // outright on stop — never soft-deleted.
            ["fin.running_timers"] = ["is_deleted", "deleted_at", "deleted_by"],

            // DB-7 (07_Ops/TaskDependencies): a pure dependency edge — insert or hard-delete
            // only, no update/soft-delete concept.
            ["ops.task_dependencies"] = ["updated_at", "updated_by", "is_deleted", "deleted_at", "deleted_by"],
        };

    /// <summary>
    /// Check 1: every table has tenant_id + the full audit trio, except columns explicitly
    /// whitelisted above. Generates a SQL assertion query (whitelist + required-columns
    /// baked in as VALUES lists) and runs it against the live verify database — any row
    /// returned is a real violation.
    /// </summary>
    public static async Task<List<string>> CheckAuditColumnsAsync(NpgsqlConnection conn)
    {
        var requiredValues = string.Join(",\n    ", RequiredColumns.Select(c => $"('{c}')"));

        var whitelistRows = AuditColumnWhitelist.SelectMany(kv =>
        {
            var parts = kv.Key.Split('.', 2);
            return kv.Value.Select(col => $"('{parts[0]}','{parts[1]}','{col}')");
        }).ToList();

        // VALUES needs at least one row; add an inert placeholder if the whitelist were ever empty.
        var whitelistValues = whitelistRows.Count > 0
            ? string.Join(",\n    ", whitelistRows)
            : "('__none__','__none__','__none__')";

        var sql = $"""
            WITH required_cols(col) AS (
              VALUES
                {requiredValues}
            ),
            whitelist(schema_name, table_name, col) AS (
              VALUES
                {whitelistValues}
            ),
            tabs AS (
              SELECT c.oid, n.nspname AS schema_name, c.relname AS table_name
              FROM pg_class c
              JOIN pg_namespace n ON n.oid = c.relnamespace
              WHERE n.nspname NOT IN ('pg_catalog', 'information_schema', 'public')
                AND c.relkind IN ('r', 'p')
                AND c.oid NOT IN (SELECT inhrelid FROM pg_inherits)
                AND c.relname <> 'dbup_schema_versions'
            )
            SELECT t.schema_name, t.table_name, rc.col
            FROM tabs t
            CROSS JOIN required_cols rc
            WHERE NOT EXISTS (
                SELECT 1 FROM pg_attribute a
                WHERE a.attrelid = t.oid AND a.attname = rc.col AND NOT a.attisdropped
              )
              AND NOT EXISTS (
                SELECT 1 FROM whitelist w
                WHERE w.schema_name = t.schema_name AND w.table_name = t.table_name AND w.col = rc.col
              )
            ORDER BY 1, 2, 3;
            """;

        var failures = new List<string>();
        await using var cmd = new NpgsqlCommand(sql, conn);
        await using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            failures.Add(
                $"{reader.GetString(0)}.{reader.GetString(1)} is missing required column '{reader.GetString(2)}' and is not whitelisted in Verification.AuditColumnWhitelist");
        }

        return failures;
    }

    private static readonly Regex RlsTableRegex = new(
        @"ALTER TABLE\s+([a-z_][a-z0-9_]*)\.([a-z_][a-z0-9_]*)\s+ENABLE ROW LEVEL SECURITY",
        RegexOptions.IgnoreCase | RegexOptions.Compiled);

    /// <summary>
    /// Scans every *.sql file under Scripts/15_RLS_Policies for
    /// "ALTER TABLE schema.table ENABLE ROW LEVEL SECURITY" statements — this is the same
    /// live-scan approach used to generate those files in the first place (DB-11), so the
    /// check can never drift from what that folder actually contains.
    /// </summary>
    public static List<(string Schema, string Table)> ScanRlsTables(string scriptsRoot)
    {
        var rlsDir = Path.Combine(scriptsRoot, "15_RLS_Policies");
        if (!Directory.Exists(rlsDir))
        {
            return [];
        }

        var tables = new SortedSet<(string, string)>();
        foreach (var file in Directory.EnumerateFiles(rlsDir, "*.sql", SearchOption.TopDirectoryOnly))
        {
            var text = File.ReadAllText(file);
            foreach (Match m in RlsTableRegex.Matches(text))
            {
                tables.Add((m.Groups[1].Value.ToLowerInvariant(), m.Groups[2].Value.ToLowerInvariant()));
            }
        }

        return tables.ToList();
    }

    /// <summary>
    /// Check 2: every table scanned by <see cref="ScanRlsTables"/> actually has both
    /// rowsecurity and forcerowsecurity turned on in the live database — catches the case
    /// where a script was written but never applied, or a later migration accidentally
    /// disabled RLS on one of these tables.
    /// </summary>
    public static async Task<List<string>> CheckRlsEnabledAsync(NpgsqlConnection conn, List<(string Schema, string Table)> rlsTables)
    {
        var failures = new List<string>();

        foreach (var (schema, table) in rlsTables)
        {
            await using var cmd = new NpgsqlCommand(
                """
                SELECT c.relrowsecurity, c.relforcerowsecurity
                FROM pg_class c
                JOIN pg_namespace n ON n.oid = c.relnamespace
                WHERE n.nspname = @schema AND c.relname = @table
                """, conn);
            cmd.Parameters.AddWithValue("schema", schema);
            cmd.Parameters.AddWithValue("table", table);

            await using var reader = await cmd.ExecuteReaderAsync();
            if (!await reader.ReadAsync())
            {
                failures.Add($"{schema}.{table} is referenced by a 15_RLS_Policies script but does not exist in the database");
                continue;
            }

            var rowSecurity = reader.GetBoolean(0);
            var forceRowSecurity = reader.GetBoolean(1);
            if (!rowSecurity || !forceRowSecurity)
            {
                failures.Add(
                    $"{schema}.{table} is referenced by a 15_RLS_Policies script but is not fully enabled (rowsecurity={rowSecurity}, forcerowsecurity={forceRowSecurity})");
            }
        }

        return failures;
    }

    /// <summary>
    /// Check 3: fin.trust_ledger_entries and audit.audit_events reject UPDATE/DELETE, proven
    /// with a real transaction rather than just reading pg_trigger. Builds the minimal fixture
    /// chain each table needs (tenant -> client -> trust_account -> trust_ledger_entries; and
    /// tenant -> audit_events), attempts the mutation, expects Postgres to reject it, and rolls
    /// the entire outer transaction back at the end so the verify database is left untouched.
    /// </summary>
    public static async Task<List<string>> CheckAppendOnlyTablesAsync(string connectionString)
    {
        var failures = new List<string>();

        await using var conn = new NpgsqlConnection(connectionString);
        await conn.OpenAsync();
        await using var tx = await conn.BeginTransactionAsync();

        var tenantId = Guid.NewGuid();
        var clientId = Guid.NewGuid();
        var trustAccountId = Guid.NewGuid();
        var ledgerEntryId = Guid.NewGuid();
        var auditEventId = Guid.NewGuid();

        try
        {
            await ExecAsync(conn, tx,
                "INSERT INTO core.tenants (id, name, slug, status, plan_tier) VALUES (@id, 'Verify Tenant', @slug, 'Active', 'Enterprise')",
                ("id", tenantId), ("slug", $"verify-{tenantId:N}"));

            await ExecAsync(conn, tx,
                "INSERT INTO crm.clients (id, tenant_id, number, type, first_name, last_name) VALUES (@id, @tenantId, 'VERIFY-001', 'Individual', 'Verify', 'Client')",
                ("id", clientId), ("tenantId", tenantId));

            await ExecAsync(conn, tx,
                "INSERT INTO fin.trust_accounts (id, tenant_id, client_id) VALUES (@id, @tenantId, @clientId)",
                ("id", trustAccountId), ("tenantId", tenantId), ("clientId", clientId));

            await ExecAsync(conn, tx,
                "INSERT INTO fin.trust_ledger_entries (id, tenant_id, trust_account_id, kind, amount, purpose) VALUES (@id, @tenantId, @trustAccountId, 'Deposit', 1000, 'verify fixture')",
                ("id", ledgerEntryId), ("tenantId", tenantId), ("trustAccountId", trustAccountId));

            await ExecAsync(conn, tx,
                "INSERT INTO audit.audit_events (id, tenant_id, actor_type, action, entity_type) VALUES (@id, @tenantId, 'system', 'create', 'verify.fixture')",
                ("id", auditEventId), ("tenantId", tenantId));

            failures.AddRange(await ExpectRejectedAsync(conn, tx,
                "fin.trust_ledger_entries UPDATE",
                $"UPDATE fin.trust_ledger_entries SET amount = 1 WHERE id = '{ledgerEntryId}'"));

            failures.AddRange(await ExpectRejectedAsync(conn, tx,
                "fin.trust_ledger_entries DELETE",
                $"DELETE FROM fin.trust_ledger_entries WHERE id = '{ledgerEntryId}'"));

            failures.AddRange(await ExpectRejectedAsync(conn, tx,
                "audit.audit_events UPDATE",
                $"UPDATE audit.audit_events SET action = 'delete' WHERE id = '{auditEventId}'"));

            failures.AddRange(await ExpectRejectedAsync(conn, tx,
                "audit.audit_events DELETE",
                $"DELETE FROM audit.audit_events WHERE id = '{auditEventId}'"));
        }
        catch (Exception ex)
        {
            failures.Add($"Append-only fixture setup failed unexpectedly: {ex.Message}");
        }
        finally
        {
            await tx.RollbackAsync();
        }

        return failures;
    }

    private static async Task ExecAsync(NpgsqlConnection conn, NpgsqlTransaction tx, string sql, params (string Name, object Value)[] parameters)
    {
        await using var cmd = new NpgsqlCommand(sql, conn, tx);
        foreach (var (name, value) in parameters)
        {
            cmd.Parameters.AddWithValue(name, value);
        }

        await cmd.ExecuteNonQueryAsync();
    }

    /// <summary>
    /// Runs `sql` inside a savepoint and expects Postgres to reject it (any PostgresException).
    /// If it unexpectedly succeeds, that's the failure being tested for. Either way, rolls back
    /// to the savepoint so the caller's outer transaction stays usable for the next check.
    /// </summary>
    private static async Task<List<string>> ExpectRejectedAsync(NpgsqlConnection conn, NpgsqlTransaction tx, string label, string sql)
    {
        var failures = new List<string>();
        const string savepoint = "verify_sp";

        await using (var save = new NpgsqlCommand($"SAVEPOINT {savepoint}", conn, tx))
        {
            await save.ExecuteNonQueryAsync();
        }

        try
        {
            await using var cmd = new NpgsqlCommand(sql, conn, tx);
            await cmd.ExecuteNonQueryAsync();
            failures.Add($"{label} was expected to be rejected by the append-only trigger, but it succeeded");
        }
        catch (PostgresException)
        {
            // Expected — the trigger did its job.
        }

        await using var rollback = new NpgsqlCommand($"ROLLBACK TO SAVEPOINT {savepoint}", conn, tx);
        await rollback.ExecuteNonQueryAsync();

        return failures;
    }
}
