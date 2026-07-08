CREATE INDEX ix_departments_tenant ON core.departments (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_departments_tenant_name ON core.departments (tenant_id, name) WHERE is_deleted = false;

CREATE INDEX ix_departments_head_user ON core.departments (head_user_id) WHERE is_deleted = false;
