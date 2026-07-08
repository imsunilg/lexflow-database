-- PROMPT DB-11 (15_RLS_Policies). PRD §14 (multi-tenant isolation
-- convention) / §20(5): "Tenant isolation: JWT tenant claim -> EF
-- global filter + PG RLS + per-tenant blob containers + per-tenant ES
-- filter + per-tenant vector namespace."
--
-- Every tenant-scoped table built in 05_DMS (table list scanned live
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

ALTER TABLE dms.document_activity ENABLE ROW LEVEL SECURITY;
ALTER TABLE dms.document_activity FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON dms.document_activity
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE dms.document_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE dms.document_permissions FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON dms.document_permissions
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE dms.document_share_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE dms.document_share_links FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON dms.document_share_links
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE dms.document_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE dms.document_tags FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON dms.document_tags
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE dms.document_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE dms.document_templates FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON dms.document_templates
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE dms.document_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE dms.document_versions FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON dms.document_versions
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE dms.documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE dms.documents FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON dms.documents
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE dms.folders ENABLE ROW LEVEL SECURITY;
ALTER TABLE dms.folders FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON dms.folders
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE dms.signature_envelopes ENABLE ROW LEVEL SECURITY;
ALTER TABLE dms.signature_envelopes FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON dms.signature_envelopes
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE dms.signature_signers ENABLE ROW LEVEL SECURITY;
ALTER TABLE dms.signature_signers FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON dms.signature_signers
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE dms.tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE dms.tags FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON dms.tags
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE dms.template_merge_fields ENABLE ROW LEVEL SECURITY;
ALTER TABLE dms.template_merge_fields FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON dms.template_merge_fields
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

