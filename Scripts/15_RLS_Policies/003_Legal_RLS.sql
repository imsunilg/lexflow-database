-- PROMPT DB-11 (15_RLS_Policies). PRD §14 (multi-tenant isolation
-- convention) / §20(5): "Tenant isolation: JWT tenant claim -> EF
-- global filter + PG RLS + per-tenant blob containers + per-tenant ES
-- filter + per-tenant vector namespace."
--
-- Every tenant-scoped table built in 04_Legal (table list scanned live
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

ALTER TABLE legal.argument_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.argument_notes FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.argument_notes
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.case_parties ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.case_parties FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.case_parties
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.court_cases ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.court_cases FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.court_cases
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.court_holidays ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.court_holidays FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.court_holidays
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.court_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.court_orders FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.court_orders
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.courts ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.courts FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.courts
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.evidence_custody_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.evidence_custody_log FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.evidence_custody_log
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.evidence_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.evidence_items FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.evidence_items
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.hearing_outcomes ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.hearing_outcomes FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.hearing_outcomes
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.hearings ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.hearings FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.hearings
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.judges ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.judges FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.judges
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.matter_expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.matter_expenses FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.matter_expenses
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.matter_important_dates ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.matter_important_dates FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.matter_important_dates
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.matter_parties ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.matter_parties FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.matter_parties
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.matter_related ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.matter_related FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.matter_related
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.matter_team_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.matter_team_members FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.matter_team_members
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.matters ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.matters FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.matters
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.practice_areas ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.practice_areas FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.practice_areas
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.witnesses ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.witnesses FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.witnesses
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

