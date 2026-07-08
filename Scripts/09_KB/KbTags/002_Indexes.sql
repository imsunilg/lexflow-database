CREATE INDEX ix_kb_tags_tenant ON kb.kb_tags (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_kb_tags_tenant_name ON kb.kb_tags (tenant_id, name) WHERE is_deleted = false;
