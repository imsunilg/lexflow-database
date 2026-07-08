-- PROMPT DB-11 (15_RLS_Policies). PRD §14 (multi-tenant isolation
-- convention) / §20(5): "Tenant isolation: JWT tenant claim -> EF
-- global filter + PG RLS + per-tenant blob containers + per-tenant ES
-- filter + per-tenant vector namespace."
--
-- Every tenant-scoped table built in 03_CRM (table list scanned live
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

ALTER TABLE crm.client_addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE crm.client_addresses FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON crm.client_addresses
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE crm.client_contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE crm.client_contacts FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON crm.client_contacts
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE crm.client_identity_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE crm.client_identity_documents FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON crm.client_identity_documents
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE crm.client_portal_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE crm.client_portal_users FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON crm.client_portal_users
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE crm.client_relationships ENABLE ROW LEVEL SECURITY;
ALTER TABLE crm.client_relationships FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON crm.client_relationships
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE crm.clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE crm.clients FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON crm.clients
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE crm.lead_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE crm.lead_activities FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON crm.lead_activities
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE crm.lead_sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE crm.lead_sources FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON crm.lead_sources
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE crm.lead_stage_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE crm.lead_stage_history FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON crm.lead_stage_history
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE crm.leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE crm.leads FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON crm.leads
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE crm.lost_reasons ENABLE ROW LEVEL SECURITY;
ALTER TABLE crm.lost_reasons FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON crm.lost_reasons
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

