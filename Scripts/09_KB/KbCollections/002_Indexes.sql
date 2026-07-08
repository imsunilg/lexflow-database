CREATE INDEX ix_kb_collections_tenant ON kb.kb_collections (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_kb_collections_tenant_name ON kb.kb_collections (tenant_id, name) WHERE is_deleted = false;
