CREATE INDEX ix_document_activity_tenant ON dms.document_activity (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_document_activity_document ON dms.document_activity (document_id, at DESC) WHERE is_deleted = false;

CREATE INDEX ix_document_activity_user ON dms.document_activity (user_id) WHERE is_deleted = false;
