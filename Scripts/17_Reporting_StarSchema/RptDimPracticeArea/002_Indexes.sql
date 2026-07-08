CREATE INDEX ix_rpt_dim_practice_area_tenant ON rpt.rpt_dim_practice_area (tenant_id);

CREATE INDEX ix_rpt_dim_practice_area_parent ON rpt.rpt_dim_practice_area (parent_key);
