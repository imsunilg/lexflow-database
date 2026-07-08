CREATE INDEX ix_tags_tenant ON dms.tags (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_tags_tenant_name ON dms.tags (tenant_id, name) WHERE is_deleted = false;
