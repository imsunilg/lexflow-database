CREATE INDEX ix_task_assignees_tenant ON ops.task_assignees (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_task_assignees_user ON ops.task_assignees (user_id) WHERE is_deleted = false;
