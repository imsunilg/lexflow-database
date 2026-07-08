CREATE INDEX ix_ip_allowlists_tenant ON core.ip_allowlists (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_ip_allowlists_role ON core.ip_allowlists (role_id) WHERE is_deleted = false;
