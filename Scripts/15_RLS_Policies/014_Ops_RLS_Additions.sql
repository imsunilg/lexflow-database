-- Additive RLS for ops.workflow_event_outbox, added after the original ops RLS pass
-- had already been applied (DbUp journals by script name, not content hash). Same
-- policy shape as every other tenant-scoped table in this folder.
ALTER TABLE ops.workflow_event_outbox ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.workflow_event_outbox FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.workflow_event_outbox
  USING (tenant_id = current_setting('app.tenant_id')::uuid);
