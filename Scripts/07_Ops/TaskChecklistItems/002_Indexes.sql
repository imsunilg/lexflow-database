CREATE INDEX ix_task_checklist_items_tenant ON ops.task_checklist_items (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_task_checklist_items_task ON ops.task_checklist_items (task_id, sort_order) WHERE is_deleted = false;
