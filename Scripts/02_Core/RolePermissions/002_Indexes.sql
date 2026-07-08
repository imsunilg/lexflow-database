CREATE INDEX ix_role_permissions_tenant ON core.role_permissions (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_role_permissions_permission ON core.role_permissions (permission_id) WHERE is_deleted = false;
