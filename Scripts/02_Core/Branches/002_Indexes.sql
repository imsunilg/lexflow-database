CREATE INDEX ix_branches_tenant ON core.branches (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_branches_tenant_code ON core.branches (tenant_id, code) WHERE is_deleted = false;
