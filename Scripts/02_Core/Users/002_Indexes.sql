CREATE INDEX ix_users_tenant ON core.users (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_users_tenant_email ON core.users (tenant_id, email) WHERE is_deleted = false;

CREATE INDEX ix_users_branch ON core.users (branch_id) WHERE is_deleted = false;

CREATE INDEX ix_users_department ON core.users (department_id) WHERE is_deleted = false;
