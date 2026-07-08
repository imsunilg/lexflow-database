CREATE INDEX ix_lost_reasons_tenant ON crm.lost_reasons (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_lost_reasons_tenant_name ON crm.lost_reasons (tenant_id, name) WHERE is_deleted = false;
