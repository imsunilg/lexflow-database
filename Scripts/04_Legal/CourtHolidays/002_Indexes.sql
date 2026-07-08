CREATE INDEX ix_court_holidays_tenant ON legal.court_holidays (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_court_holidays_court_date ON legal.court_holidays (court_id, holiday_date) WHERE is_deleted = false;
