CREATE INDEX ix_lead_sources_tenant ON crm.lead_sources (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_lead_sources_tenant_name ON crm.lead_sources (tenant_id, name) WHERE is_deleted = false;
