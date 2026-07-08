CREATE INDEX ix_kb_collection_items_tenant ON kb.kb_collection_items (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_kb_collection_items_collection_ref ON kb.kb_collection_items (collection_id, kb_ref_kind, kb_ref_id) WHERE is_deleted = false;
