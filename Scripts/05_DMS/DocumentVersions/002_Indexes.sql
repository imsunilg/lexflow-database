CREATE INDEX ix_document_versions_tenant ON dms.document_versions (tenant_id) WHERE is_deleted = false;

-- Explicit prompt requirement: document_versions UNIQUE(document_id, version_no).
CREATE UNIQUE INDEX ux_document_versions_document_version ON dms.document_versions (document_id, version_no) WHERE is_deleted = false;
