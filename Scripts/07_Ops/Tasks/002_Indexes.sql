CREATE INDEX ix_tasks_tenant ON ops.tasks (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_tasks_owner_status ON ops.tasks (tenant_id, owner_id, status) WHERE is_deleted = false;

CREATE INDEX ix_tasks_matter ON ops.tasks (matter_id) WHERE is_deleted = false;

CREATE INDEX ix_tasks_client ON ops.tasks (client_id) WHERE is_deleted = false;

CREATE INDEX ix_tasks_due_at ON ops.tasks (tenant_id, due_at) WHERE is_deleted = false AND status NOT IN ('Done', 'Cancelled');

CREATE UNIQUE INDEX ux_tasks_tenant_number ON ops.tasks (tenant_id, number) WHERE is_deleted = false AND number IS NOT NULL;
