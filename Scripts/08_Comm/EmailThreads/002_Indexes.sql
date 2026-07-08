CREATE INDEX ix_email_threads_tenant ON comm.email_threads (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_email_threads_matter ON comm.email_threads (matter_id) WHERE is_deleted = false;

CREATE INDEX ix_email_threads_client ON comm.email_threads (client_id) WHERE is_deleted = false;

CREATE INDEX ix_email_threads_mailbox ON comm.email_threads (mailbox_id) WHERE is_deleted = false;
