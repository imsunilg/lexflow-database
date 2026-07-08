CREATE INDEX ix_document_permissions_tenant ON dms.document_permissions (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_document_permissions_document ON dms.document_permissions (document_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_document_permissions_document_principal ON dms.document_permissions (document_id, principal_type, principal_id) WHERE is_deleted = false;
