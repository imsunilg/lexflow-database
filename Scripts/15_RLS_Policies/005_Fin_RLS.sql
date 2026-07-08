-- PROMPT DB-11 (15_RLS_Policies). PRD §14 (multi-tenant isolation
-- convention) / §20(5): "Tenant isolation: JWT tenant claim -> EF
-- global filter + PG RLS + per-tenant blob containers + per-tenant ES
-- filter + per-tenant vector namespace."
--
-- Every tenant-scoped table built in 06_Fin (table list scanned live
-- from information_schema/pg_catalog: every base/partitioned table in
-- this schema carrying a tenant_id column, excluding partition-child
-- tables since RLS on a partitioned parent automatically propagates to
-- all its partitions — unlike GRANT/REVOKE, which does not, see
-- 10_Audit/AuditEvents/004_Functions.sql).
--
-- FORCE ROW LEVEL SECURITY makes the policy apply even to the table
-- owner (by default an owner bypasses RLS). NOTE: a superuser always
-- bypasses RLS regardless of FORCE — these migrations run as the
-- postgres superuser, so FORCE has no effect on that connection. It
-- takes effect once the API's runtime role (lexflow_app, created in
-- 10_Audit/AuditEvents/003_Insert_Only_Trigger.sql) owns or is granted
-- rights on these tables and is NOT a superuser, per the explicit
-- prompt requirement.
--
-- app.tenant_id is expected to be set per-connection/transaction by the
-- API (e.g. SET LOCAL app.tenant_id = '<uuid>' inside each request's
-- transaction, sourced from the validated JWT tenant claim).

ALTER TABLE fin.activity_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.activity_codes FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.activity_codes
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.billing_arrangements ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.billing_arrangements FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.billing_arrangements
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.credit_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.credit_notes FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.credit_notes
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.dunning_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.dunning_events FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.dunning_events
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.dunning_schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.dunning_schedules FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.dunning_schedules
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.invoice_lines ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.invoice_lines FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.invoice_lines
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.invoice_taxes ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.invoice_taxes FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.invoice_taxes
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.invoices FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.invoices
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.number_series ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.number_series FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.number_series
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.payment_allocations ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.payment_allocations FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.payment_allocations
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.payments FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.payments
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.rate_card_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.rate_card_entries FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.rate_card_entries
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.rate_cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.rate_cards FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.rate_cards
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.refunds ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.refunds FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.refunds
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.running_timers ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.running_timers FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.running_timers
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.tax_configs ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.tax_configs FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.tax_configs
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.time_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.time_entries FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.time_entries
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.trust_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.trust_accounts FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.trust_accounts
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.trust_ledger_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.trust_ledger_entries FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.trust_ledger_entries
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

