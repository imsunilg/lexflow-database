CREATE UNIQUE INDEX ux_rpt_fact_matters_tenant_matter ON rpt.rpt_fact_matters (tenant_id, matter_id);

CREATE INDEX ix_rpt_fact_matters_opened ON rpt.rpt_fact_matters (tenant_id, opened_date_key);

CREATE INDEX ix_rpt_fact_matters_closed ON rpt.rpt_fact_matters (tenant_id, closed_date_key);

CREATE INDEX ix_rpt_fact_matters_lawyer ON rpt.rpt_fact_matters (tenant_id, lawyer_key);

CREATE INDEX ix_rpt_fact_matters_client ON rpt.rpt_fact_matters (tenant_id, client_key);

CREATE INDEX ix_rpt_fact_matters_practice_area ON rpt.rpt_fact_matters (tenant_id, practice_area_key);

CREATE INDEX ix_rpt_fact_matters_branch ON rpt.rpt_fact_matters (tenant_id, branch_id);

CREATE INDEX ix_rpt_fact_matters_status ON rpt.rpt_fact_matters (tenant_id, status);
