CREATE INDEX ix_template_merge_fields_tenant ON dms.template_merge_fields (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_template_merge_fields_template_key ON dms.template_merge_fields (template_id, field_key) WHERE is_deleted = false;
