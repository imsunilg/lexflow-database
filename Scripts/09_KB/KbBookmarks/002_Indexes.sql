CREATE INDEX ix_kb_bookmarks_tenant ON kb.kb_bookmarks (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_kb_bookmarks_user_ref ON kb.kb_bookmarks (user_id, kb_ref_kind, kb_ref_id) WHERE is_deleted = false;
