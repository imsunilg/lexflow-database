CREATE INDEX ix_document_share_links_tenant ON dms.document_share_links (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_document_share_links_document ON dms.document_share_links (document_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_document_share_links_token_hash ON dms.document_share_links (token_hash) WHERE is_deleted = false;
