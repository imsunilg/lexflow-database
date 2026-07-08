CREATE INDEX ix_user_roles_tenant ON core.user_roles (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_user_roles_role ON core.user_roles (role_id) WHERE is_deleted = false;
