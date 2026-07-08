CREATE INDEX ix_mailboxes_tenant ON comm.mailboxes (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_mailboxes_user_email ON comm.mailboxes (user_id, email_address) WHERE is_deleted = false;
