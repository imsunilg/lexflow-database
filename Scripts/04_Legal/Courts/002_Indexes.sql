CREATE INDEX ix_courts_tenant ON legal.courts (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_courts_level ON legal.courts (tenant_id, level) WHERE is_deleted = false;
