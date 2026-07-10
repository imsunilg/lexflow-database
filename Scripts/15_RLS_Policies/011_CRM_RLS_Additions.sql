-- Additive RLS for crm.lead_import_batches, added after 002_CRM_RLS.sql had
-- already been applied (DbUp journals by script name, not content hash).
-- Same policy shape as every other table in 002_CRM_RLS.sql.
ALTER TABLE crm.lead_import_batches ENABLE ROW LEVEL SECURITY;
ALTER TABLE crm.lead_import_batches FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON crm.lead_import_batches
  USING (tenant_id = current_setting('app.tenant_id')::uuid);
