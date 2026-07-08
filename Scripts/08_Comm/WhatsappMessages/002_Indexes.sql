CREATE INDEX ix_whatsapp_messages_tenant ON comm.whatsapp_messages (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_whatsapp_messages_client ON comm.whatsapp_messages (client_id, created_at DESC) WHERE is_deleted = false;

-- Explicit prompt requirement: whatsapp_messages UNIQUE(wa_msg_id).
CREATE UNIQUE INDEX ux_whatsapp_messages_wa_msg_id ON comm.whatsapp_messages (wa_msg_id) WHERE is_deleted = false;
