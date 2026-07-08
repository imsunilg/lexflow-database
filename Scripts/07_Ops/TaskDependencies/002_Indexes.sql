CREATE INDEX ix_task_dependencies_tenant ON ops.task_dependencies (tenant_id);

CREATE INDEX ix_task_dependencies_depends_on ON ops.task_dependencies (depends_on_task_id);
