CREATE UNIQUE INDEX ux_rpt_fact_time_tenant_entry ON rpt.rpt_fact_time (tenant_id, time_entry_id);

CREATE INDEX ix_rpt_fact_time_date ON rpt.rpt_fact_time (tenant_id, date_key);

CREATE INDEX ix_rpt_fact_time_lawyer ON rpt.rpt_fact_time (tenant_id, lawyer_key);

CREATE INDEX ix_rpt_fact_time_client ON rpt.rpt_fact_time (tenant_id, client_key);

CREATE INDEX ix_rpt_fact_time_practice_area ON rpt.rpt_fact_time (tenant_id, practice_area_key);

CREATE INDEX ix_rpt_fact_time_matter ON rpt.rpt_fact_time (tenant_id, matter_id);
