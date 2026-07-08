CREATE INDEX ix_matter_parties_tenant ON legal.matter_parties (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_matter_parties_matter ON legal.matter_parties (matter_id) WHERE is_deleted = false;
