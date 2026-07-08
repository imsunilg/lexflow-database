CREATE INDEX ix_sms_messages_tenant ON comm.sms_messages (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_sms_messages_client ON comm.sms_messages (client_id, sent_at DESC) WHERE is_deleted = false;

CREATE INDEX ix_sms_messages_matter ON comm.sms_messages (matter_id) WHERE is_deleted = false;
