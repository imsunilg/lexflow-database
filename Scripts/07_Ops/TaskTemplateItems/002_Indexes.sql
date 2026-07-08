CREATE INDEX ix_task_template_items_tenant ON ops.task_template_items (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_task_template_items_template ON ops.task_template_items (template_id, sort_order) WHERE is_deleted = false;
