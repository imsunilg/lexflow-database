CREATE INDEX ix_document_tags_tenant ON dms.document_tags (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_document_tags_tag ON dms.document_tags (tag_id) WHERE is_deleted = false;
