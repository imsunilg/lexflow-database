CREATE INDEX ix_chat_channels_tenant ON comm.chat_channels (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_chat_channels_matter ON comm.chat_channels (matter_id) WHERE is_deleted = false;

CREATE INDEX ix_chat_channels_team ON comm.chat_channels (team_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_chat_channels_matter_auto ON comm.chat_channels (matter_id) WHERE kind = 'Matter' AND is_deleted = false;
