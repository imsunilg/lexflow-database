-- PRD §14 (multi-tenant isolation convention) / §20(5). RLS for the rpt
-- schema. Lives inside this folder (rather than 15_RLS_Policies, where every
-- other schema's policies live) because 15_RLS_Policies executes before
-- 17_Reporting_StarSchema in the top-level folder order (Build Playbook
-- §1.1) — the rpt.* tables wouldn't exist yet. The "zzz_" prefix sorts this
-- file after every table folder in this directory (000_Schema.sql, then
-- ReportDefinitions/ReportRuns/ReportSchedules/RptDim*/RptFact*
-- alphabetically), so every table below already exists when this runs.
--
-- rpt.rpt_dim_date is deliberately excluded — per its own 001_Table.sql
-- comment, calendar rows carry no tenant_id and are shared across every
-- tenant.
--
-- Every CREATE POLICY below is preceded by a DROP POLICY IF EXISTS: an
-- earlier, differently-located version of this script (see git history)
-- partially applied against the six rpt_dim_*/rpt_fact_* tables before
-- failing on a table that didn't exist yet at that location, leaving those
-- six policies already created — this makes the script safe to (re)run
-- regardless of that history.

ALTER TABLE rpt.rpt_dim_lawyer ENABLE ROW LEVEL SECURITY;
ALTER TABLE rpt.rpt_dim_lawyer FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON rpt.rpt_dim_lawyer;
CREATE POLICY tenant_isolation ON rpt.rpt_dim_lawyer
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE rpt.rpt_dim_client ENABLE ROW LEVEL SECURITY;
ALTER TABLE rpt.rpt_dim_client FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON rpt.rpt_dim_client;
CREATE POLICY tenant_isolation ON rpt.rpt_dim_client
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE rpt.rpt_dim_practice_area ENABLE ROW LEVEL SECURITY;
ALTER TABLE rpt.rpt_dim_practice_area FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON rpt.rpt_dim_practice_area;
CREATE POLICY tenant_isolation ON rpt.rpt_dim_practice_area
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE rpt.rpt_fact_billing ENABLE ROW LEVEL SECURITY;
ALTER TABLE rpt.rpt_fact_billing FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON rpt.rpt_fact_billing;
CREATE POLICY tenant_isolation ON rpt.rpt_fact_billing
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE rpt.rpt_fact_time ENABLE ROW LEVEL SECURITY;
ALTER TABLE rpt.rpt_fact_time FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON rpt.rpt_fact_time;
CREATE POLICY tenant_isolation ON rpt.rpt_fact_time
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE rpt.rpt_fact_matters ENABLE ROW LEVEL SECURITY;
ALTER TABLE rpt.rpt_fact_matters FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON rpt.rpt_fact_matters;
CREATE POLICY tenant_isolation ON rpt.rpt_fact_matters
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE rpt.report_definitions ENABLE ROW LEVEL SECURITY;
ALTER TABLE rpt.report_definitions FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON rpt.report_definitions;
CREATE POLICY tenant_isolation ON rpt.report_definitions
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE rpt.report_schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE rpt.report_schedules FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON rpt.report_schedules;
CREATE POLICY tenant_isolation ON rpt.report_schedules
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE rpt.report_runs ENABLE ROW LEVEL SECURITY;
ALTER TABLE rpt.report_runs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON rpt.report_runs;
CREATE POLICY tenant_isolation ON rpt.report_runs
  USING (tenant_id = current_setting('app.tenant_id')::uuid);
