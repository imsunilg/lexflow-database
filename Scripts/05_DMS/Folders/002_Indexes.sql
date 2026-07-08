CREATE INDEX ix_folders_tenant ON dms.folders (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_folders_parent ON dms.folders (parent_id) WHERE is_deleted = false;

CREATE INDEX ix_folders_matter ON dms.folders (matter_id) WHERE is_deleted = false;

CREATE INDEX ix_folders_path ON dms.folders USING gist (path) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_folders_tenant_parent_name ON dms.folders (tenant_id, parent_id, name) WHERE is_deleted = false;
