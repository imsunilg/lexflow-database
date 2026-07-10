-- Additive RLS for dms.document_index_outbox, added after 004_DMS_RLS.sql had
-- already been applied (DbUp journals by script name, not content hash). Same
-- policy shape as every other table in 004_DMS_RLS.sql.
ALTER TABLE dms.document_index_outbox ENABLE ROW LEVEL SECURITY;
ALTER TABLE dms.document_index_outbox FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON dms.document_index_outbox
  USING (tenant_id = current_setting('app.tenant_id')::uuid);
