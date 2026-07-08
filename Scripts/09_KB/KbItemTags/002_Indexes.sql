CREATE INDEX ix_kb_item_tags_tenant ON kb.kb_item_tags (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_kb_item_tags_ref ON kb.kb_item_tags (kb_ref_kind, kb_ref_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_kb_item_tags_tag_ref ON kb.kb_item_tags (tag_id, kb_ref_kind, kb_ref_id) WHERE is_deleted = false;
