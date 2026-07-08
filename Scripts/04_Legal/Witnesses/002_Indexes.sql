CREATE INDEX ix_witnesses_tenant ON legal.witnesses (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_witnesses_case ON legal.witnesses (case_id) WHERE is_deleted = false;
