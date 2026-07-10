-- Additive RLS for ops.calendar_ics_tokens, added after 014_Ops_RLS_Additions.sql had
-- already been applied (DbUp journals by script name, not content hash). Same policy
-- shape as every other tenant-scoped table in this folder.
ALTER TABLE ops.calendar_ics_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.calendar_ics_tokens FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.calendar_ics_tokens
  USING (tenant_id = current_setting('app.tenant_id')::uuid);
