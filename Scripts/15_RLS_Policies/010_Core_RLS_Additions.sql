-- Additive RLS for core.tenant_settings and core.gateway_configs, added
-- after 001_Core_RLS.sql had already been applied (DbUp journals by script
-- name, not content hash — editing 001_Core_RLS.sql in place would never
-- re-run against an environment where it already succeeded). Same policy
-- shape as every other 02_Core table; see 001_Core_RLS.sql's header comment
-- for the full rationale (FORCE ROW LEVEL SECURITY, app.tenant_id).
ALTER TABLE core.tenant_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE core.tenant_settings FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON core.tenant_settings
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE core.gateway_configs ENABLE ROW LEVEL SECURITY;
ALTER TABLE core.gateway_configs FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON core.gateway_configs
  USING (tenant_id = current_setting('app.tenant_id')::uuid);
