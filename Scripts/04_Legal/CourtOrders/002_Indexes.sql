CREATE INDEX ix_court_orders_tenant ON legal.court_orders (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_court_orders_case ON legal.court_orders (case_id) WHERE is_deleted = false;

CREATE INDEX ix_court_orders_hearing ON legal.court_orders (hearing_id) WHERE is_deleted = false;

CREATE INDEX ix_court_orders_compliance_due ON legal.court_orders (compliance_due) WHERE is_deleted = false;
