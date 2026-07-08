CREATE INDEX ix_permissions_tenant ON core.permissions (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_permissions_tenant_key ON core.permissions (tenant_id, key) WHERE is_deleted = false;
