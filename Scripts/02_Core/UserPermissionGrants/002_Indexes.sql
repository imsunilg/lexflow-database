CREATE INDEX ix_upg_tenant ON core.user_permission_grants (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_upg_permission ON core.user_permission_grants (permission_id) WHERE is_deleted = false;
