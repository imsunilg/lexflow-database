-- PROMPT DB-11 (15_RLS_Policies). PRD §14 (multi-tenant isolation
-- convention) / §20(5): "Tenant isolation: JWT tenant claim -> EF
-- global filter + PG RLS + per-tenant blob containers + per-tenant ES
-- filter + per-tenant vector namespace."
--
-- Every tenant-scoped table built in 08_Comm (table list scanned live
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

ALTER TABLE comm.call_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE comm.call_logs FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON comm.call_logs
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE comm.chat_channels ENABLE ROW LEVEL SECURITY;
ALTER TABLE comm.chat_channels FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON comm.chat_channels
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE comm.chat_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE comm.chat_members FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON comm.chat_members
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE comm.chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE comm.chat_messages FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON comm.chat_messages
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE comm.comm_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE comm.comm_templates FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON comm.comm_templates
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE comm.email_attachments ENABLE ROW LEVEL SECURITY;
ALTER TABLE comm.email_attachments FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON comm.email_attachments
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE comm.email_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE comm.email_messages FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON comm.email_messages
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE comm.email_threads ENABLE ROW LEVEL SECURITY;
ALTER TABLE comm.email_threads FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON comm.email_threads
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE comm.mailboxes ENABLE ROW LEVEL SECURITY;
ALTER TABLE comm.mailboxes FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON comm.mailboxes
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE comm.sms_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE comm.sms_messages FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON comm.sms_messages
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE comm.whatsapp_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE comm.whatsapp_messages FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON comm.whatsapp_messages
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE comm.whatsapp_optins ENABLE ROW LEVEL SECURITY;
ALTER TABLE comm.whatsapp_optins FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON comm.whatsapp_optins
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

