-- PROMPT DB-11 (15_RLS_Policies). PRD §14 (multi-tenant isolation
-- convention) / §20(5): "Tenant isolation: JWT tenant claim -> EF
-- global filter + PG RLS + per-tenant blob containers + per-tenant ES
-- filter + per-tenant vector namespace."
--
-- Every tenant-scoped table built in 02_Core (table list scanned live
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

ALTER TABLE core.branches ENABLE ROW LEVEL SECURITY;
ALTER TABLE core.branches FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON core.branches
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE core.departments ENABLE ROW LEVEL SECURITY;
ALTER TABLE core.departments FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON core.departments
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE core.ip_allowlists ENABLE ROW LEVEL SECURITY;
ALTER TABLE core.ip_allowlists FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON core.ip_allowlists
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE core.login_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE core.login_history FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON core.login_history
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE core.permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE core.permissions FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON core.permissions
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE core.role_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE core.role_permissions FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON core.role_permissions
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE core.roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE core.roles FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON core.roles
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE core.team_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE core.team_members FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON core.team_members
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE core.teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE core.teams FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON core.teams
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE core.user_permission_grants ENABLE ROW LEVEL SECURITY;
ALTER TABLE core.user_permission_grants FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON core.user_permission_grants
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE core.user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE core.user_roles FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON core.user_roles
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE core.user_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE core.user_sessions FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON core.user_sessions
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE core.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE core.users FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON core.users
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

