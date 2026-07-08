-- PROMPT DB-11 (15_RLS_Policies). PRD §14 (multi-tenant isolation
-- convention) / §20(5): "Tenant isolation: JWT tenant claim -> EF
-- global filter + PG RLS + per-tenant blob containers + per-tenant ES
-- filter + per-tenant vector namespace."
--
-- Every tenant-scoped table built in 07_Ops (table list scanned live
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

ALTER TABLE ops.calendar_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.calendar_events FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.calendar_events
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ops.event_attendees ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.event_attendees FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.event_attendees
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ops.event_reminders ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.event_reminders FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.event_reminders
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ops.external_calendar_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.external_calendar_accounts FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.external_calendar_accounts
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ops.external_event_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.external_event_links FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.external_event_links
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ops.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.notifications FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.notifications
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ops.recurrence_exceptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.recurrence_exceptions FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.recurrence_exceptions
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ops.reminder_dispatch_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.reminder_dispatch_log FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.reminder_dispatch_log
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ops.task_assignees ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.task_assignees FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.task_assignees
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ops.task_checklist_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.task_checklist_items FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.task_checklist_items
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ops.task_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.task_comments FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.task_comments
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ops.task_dependencies ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.task_dependencies FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.task_dependencies
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ops.task_template_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.task_template_items FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.task_template_items
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ops.task_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.task_templates FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.task_templates
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ops.tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.tasks FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.tasks
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ops.workflow_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.workflow_rules FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.workflow_rules
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ops.workflow_runs ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.workflow_runs FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ops.workflow_runs
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

