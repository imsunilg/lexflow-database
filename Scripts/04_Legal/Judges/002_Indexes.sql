CREATE INDEX ix_judges_tenant ON legal.judges (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_judges_court ON legal.judges (court_id) WHERE is_deleted = false;
