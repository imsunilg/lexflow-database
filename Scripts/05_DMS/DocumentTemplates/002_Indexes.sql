CREATE INDEX ix_document_templates_tenant ON dms.document_templates (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_document_templates_tenant_name ON dms.document_templates (tenant_id, name) WHERE is_deleted = false;
