CREATE INDEX ix_matter_related_tenant ON legal.matter_related (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_matter_related_matter ON legal.matter_related (matter_id) WHERE is_deleted = false;

CREATE INDEX ix_matter_related_related_matter ON legal.matter_related (related_matter_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_matter_related_pair_type ON legal.matter_related (matter_id, related_matter_id, relation_type)
  WHERE is_deleted = false;
