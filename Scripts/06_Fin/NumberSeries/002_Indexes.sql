CREATE INDEX ix_number_series_tenant ON fin.number_series (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_number_series_tenant_branch_key_fy ON fin.number_series (tenant_id, branch_id, series_key, fiscal_year) WHERE is_deleted = false;
