CREATE INDEX ix_task_comments_tenant ON ops.task_comments (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_task_comments_task ON ops.task_comments (task_id, created_at) WHERE is_deleted = false;
