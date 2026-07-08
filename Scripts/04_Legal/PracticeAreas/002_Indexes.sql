CREATE INDEX ix_practice_areas_tenant ON legal.practice_areas (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_practice_areas_tenant_name ON legal.practice_areas (tenant_id, name) WHERE is_deleted = false;

CREATE INDEX ix_practice_areas_parent ON legal.practice_areas (parent_id) WHERE is_deleted = false;
