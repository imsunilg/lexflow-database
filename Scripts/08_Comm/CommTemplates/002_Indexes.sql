CREATE INDEX ix_comm_templates_tenant ON comm.comm_templates (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_comm_templates_tenant_channel_name ON comm.comm_templates (tenant_id, channel, name) WHERE is_deleted = false;
