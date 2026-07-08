CREATE UNIQUE INDEX ux_rpt_fact_billing_tenant_invoice ON rpt.rpt_fact_billing (tenant_id, invoice_id);

CREATE INDEX ix_rpt_fact_billing_date ON rpt.rpt_fact_billing (tenant_id, date_key);

CREATE INDEX ix_rpt_fact_billing_lawyer ON rpt.rpt_fact_billing (tenant_id, lawyer_key);

CREATE INDEX ix_rpt_fact_billing_client ON rpt.rpt_fact_billing (tenant_id, client_key);

CREATE INDEX ix_rpt_fact_billing_practice_area ON rpt.rpt_fact_billing (tenant_id, practice_area_key);

CREATE INDEX ix_rpt_fact_billing_branch ON rpt.rpt_fact_billing (tenant_id, branch_id);
