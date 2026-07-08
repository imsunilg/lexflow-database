CREATE INDEX ix_activity_codes_tenant ON fin.activity_codes (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_activity_codes_tenant_name ON fin.activity_codes (tenant_id, name) WHERE is_deleted = false;
