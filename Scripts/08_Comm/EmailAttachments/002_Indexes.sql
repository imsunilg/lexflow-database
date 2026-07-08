CREATE INDEX ix_email_attachments_tenant ON comm.email_attachments (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_email_attachments_message ON comm.email_attachments (message_id) WHERE is_deleted = false;
