CREATE INDEX ix_task_templates_tenant ON ops.task_templates (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_task_templates_tenant_name ON ops.task_templates (tenant_id, name) WHERE is_deleted = false;
