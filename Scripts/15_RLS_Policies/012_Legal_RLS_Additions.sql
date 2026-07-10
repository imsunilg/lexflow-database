-- Additive RLS for legal.matter_status_history and legal.case_stage_history,
-- added after 003_Legal_RLS.sql had already been applied (DbUp journals by
-- script name, not content hash). Same policy shape as every other table in
-- 003_Legal_RLS.sql.
ALTER TABLE legal.matter_status_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.matter_status_history FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.matter_status_history
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE legal.case_stage_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE legal.case_stage_history FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON legal.case_stage_history
  USING (tenant_id = current_setting('app.tenant_id')::uuid);
