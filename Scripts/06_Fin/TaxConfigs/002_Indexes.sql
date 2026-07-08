CREATE INDEX ix_tax_configs_tenant ON fin.tax_configs (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_tax_configs_tenant_branch_country_type ON fin.tax_configs (tenant_id, branch_id, country_code, tax_type) WHERE is_deleted = false;
