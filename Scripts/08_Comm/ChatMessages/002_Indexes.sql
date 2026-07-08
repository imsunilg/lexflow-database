CREATE INDEX ix_chat_messages_tenant ON comm.chat_messages (tenant_id) WHERE is_deleted = false;

-- Keyset pagination: WHERE channel_id = ? AND seq > ? ORDER BY seq LIMIT ?.
CREATE UNIQUE INDEX ux_chat_messages_channel_seq ON comm.chat_messages (channel_id, seq) WHERE is_deleted = false;

CREATE INDEX ix_chat_messages_task ON comm.chat_messages (task_id) WHERE is_deleted = false;
