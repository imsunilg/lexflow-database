CREATE INDEX ix_dunning_schedules_tenant ON fin.dunning_schedules (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_dunning_schedules_tenant_name ON fin.dunning_schedules (tenant_id, name) WHERE is_deleted = false;
