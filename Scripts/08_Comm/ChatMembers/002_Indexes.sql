CREATE INDEX ix_chat_members_tenant ON comm.chat_members (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_chat_members_user ON comm.chat_members (user_id) WHERE is_deleted = false;
