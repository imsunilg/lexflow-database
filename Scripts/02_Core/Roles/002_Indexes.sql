CREATE INDEX ix_roles_tenant ON core.roles (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_roles_tenant_key ON core.roles (tenant_id, key) WHERE is_deleted = false;
