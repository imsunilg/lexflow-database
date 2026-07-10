-- Additive RLS for core.webhook_events, added after the original core RLS pass had
-- already been applied (DbUp journals by script name, not content hash). Same policy
-- shape as every other tenant-scoped table in this folder.
ALTER TABLE core.webhook_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE core.webhook_events FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON core.webhook_events
  USING (tenant_id = current_setting('app.tenant_id')::uuid);
