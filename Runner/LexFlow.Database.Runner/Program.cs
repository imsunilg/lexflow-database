using DbUp;
using Microsoft.Extensions.Configuration;
using Npgsql;
using Testcontainers.PostgreSql;

namespace LexFlow.Database.Runner;

internal static class Program
{
    private static async Task<int> Main(string[] args)
    {
        var dryRun = args.Contains("--dry-run");
        var verifyOnly = args.Contains("--verify-only");
        var scriptsPathArg = GetArgValue(args, "--scripts-path");

        var configuration = new ConfigurationBuilder()
            .SetBasePath(AppContext.BaseDirectory)
            .AddJsonFile("appsettings.json", optional: true, reloadOnChange: false)
            .AddJsonFile("appsettings.Development.json", optional: true, reloadOnChange: false)
            .AddEnvironmentVariables()
            .AddCommandLine(args)
            .Build();

        var scriptsRoot = ResolveScriptsRoot(scriptsPathArg);
        if (scriptsRoot is null)
        {
            Console.Error.WriteLine("Could not locate a 'Scripts' folder. Pass --scripts-path <dir> to specify one explicitly.");
            return 1;
        }

        var scripts = DiscoverScripts(scriptsRoot);

        if (scripts.Count == 0)
        {
            Console.WriteLine($"No .sql scripts found under '{scriptsRoot}'.");
            return 0;
        }

        if (dryRun)
        {
            Console.WriteLine($"Dry run — {scripts.Count} script(s) would execute in this order:");
            foreach (var script in scripts)
            {
                Console.WriteLine($"  {script.Name}");
            }

            return 0;
        }

        if (verifyOnly)
        {
            return await RunVerifyOnlyAsync(scriptsRoot, scripts);
        }

        var connectionString = ResolveConnectionString(configuration);
        if (string.IsNullOrWhiteSpace(connectionString))
        {
            Console.Error.WriteLine(
                "No connection string configured. Set the LEXFLOW_DB_CONNECTION environment variable " +
                "or ConnectionStrings:LexFlowDatabase in appsettings.json.");
            return 1;
        }

        var upgrader = DeployChanges.To
            .PostgresqlDatabase(connectionString)
            .WithScripts(scripts)
            .JournalToPostgresqlTable("public", "dbup_schema_versions")
            .LogToConsole()
            .Build();

        var result = upgrader.PerformUpgrade();

        if (!result.Successful)
        {
            Console.Error.WriteLine(result.Error);
            return 1;
        }

        Console.WriteLine($"Success — {scripts.Count} script(s) considered, database is up to date.");
        return 0;
    }

    /// <summary>
    /// --verify-only: applies every script to a throwaway Testcontainers-managed PostgreSQL
    /// 16 instance (no external DB needed — this is why it's safe to run on any dev machine
    /// or CI runner with Docker, not just against a pre-provisioned database), then runs the
    /// three assertion checks from Verification.cs. Requires Docker to be available; the
    /// container is always torn down on exit, success or failure.
    /// </summary>
    private static async Task<int> RunVerifyOnlyAsync(string scriptsRoot, List<DbUp.Engine.SqlScript> scripts)
    {
        Console.WriteLine("Starting a throwaway PostgreSQL 16 Testcontainer for --verify-only...");

        await using var container = new PostgreSqlBuilder()
            .WithImage("postgres:16")
            .WithDatabase("lexflow_verify")
            .WithUsername("postgres")
            .WithPassword("postgres")
            .Build();

        await container.StartAsync();
        var connectionString = container.GetConnectionString();
        Console.WriteLine("Container started. Applying all scripts...");

        var upgrader = DeployChanges.To
            .PostgresqlDatabase(connectionString)
            .WithScripts(scripts)
            .JournalToPostgresqlTable("public", "dbup_schema_versions")
            .LogToConsole()
            .Build();

        var result = upgrader.PerformUpgrade();
        if (!result.Successful)
        {
            Console.Error.WriteLine("Migration failed against the verify container:");
            Console.Error.WriteLine(result.Error);
            return 1;
        }

        Console.WriteLine($"Migrations applied ({scripts.Count} scripts). Running verification assertions...");

        var failures = new List<string>();

        await using (var conn = new NpgsqlConnection(connectionString))
        {
            await conn.OpenAsync();

            Console.WriteLine("[1/3] Checking tenant_id + audit columns on every table (except whitelisted)...");
            failures.AddRange(await Verification.CheckAuditColumnsAsync(conn));

            Console.WriteLine("[2/3] Cross-checking every table referenced by 15_RLS_Policies actually has RLS enabled...");
            var rlsTables = Verification.ScanRlsTables(scriptsRoot);
            Console.WriteLine($"      Found {rlsTables.Count} table reference(s) across 15_RLS_Policies/*.sql.");
            failures.AddRange(await Verification.CheckRlsEnabledAsync(conn, rlsTables));
        }

        Console.WriteLine("[3/3] Verifying trust_ledger_entries and audit_events reject UPDATE/DELETE...");
        failures.AddRange(await Verification.CheckAppendOnlyTablesAsync(connectionString));

        if (failures.Count > 0)
        {
            Console.Error.WriteLine();
            Console.Error.WriteLine($"VERIFY FAILED — {failures.Count} issue(s):");
            foreach (var failure in failures)
            {
                Console.Error.WriteLine($"  - {failure}");
            }

            return 1;
        }

        Console.WriteLine();
        Console.WriteLine("VERIFY PASSED — all checks green.");
        return 0;
    }

    private static string? ResolveConnectionString(IConfiguration configuration)
    {
        var fromEnv = Environment.GetEnvironmentVariable("LEXFLOW_DB_CONNECTION");
        if (!string.IsNullOrWhiteSpace(fromEnv))
        {
            return fromEnv;
        }

        return configuration.GetConnectionString("LexFlowDatabase");
    }

    /// <summary>
    /// DbUp orders scripts by name, so scripts are pre-sorted here using the full
    /// relative path (e.g. "02_Core/Users/001_Table.sql") as that Name — this is what
    /// guarantees 00_.../001_...sql runs before 01_.../001_...sql, per Build Playbook §1.1.
    /// </summary>
    private static List<DbUp.Engine.SqlScript> DiscoverScripts(string scriptsRoot)
    {
        return Directory.EnumerateFiles(scriptsRoot, "*.sql", SearchOption.AllDirectories)
            .Select(path => new
            {
                Path = path,
                RelativeName = Path.GetRelativePath(scriptsRoot, path).Replace('\\', '/')
            })
            .OrderBy(x => x.RelativeName, StringComparer.Ordinal)
            .Select(x => new DbUp.Engine.SqlScript(x.RelativeName, File.ReadAllText(x.Path)))
            .ToList();
    }

    private static string? ResolveScriptsRoot(string? explicitPath)
    {
        if (!string.IsNullOrWhiteSpace(explicitPath))
        {
            return Directory.Exists(explicitPath) ? Path.GetFullPath(explicitPath) : null;
        }

        // Try the current working directory first (the common case: `dotnet run` from repo root).
        var candidates = new[] { Directory.GetCurrentDirectory(), AppContext.BaseDirectory };

        foreach (var start in candidates)
        {
            var dir = new DirectoryInfo(start);
            for (var i = 0; i < 8 && dir is not null; i++, dir = dir.Parent)
            {
                var candidate = Path.Combine(dir.FullName, "Scripts");
                if (Directory.Exists(candidate))
                {
                    return candidate;
                }
            }
        }

        return null;
    }

    private static string? GetArgValue(string[] args, string name)
    {
        var index = Array.IndexOf(args, name);
        return index >= 0 && index + 1 < args.Length ? args[index + 1] : null;
    }
}
