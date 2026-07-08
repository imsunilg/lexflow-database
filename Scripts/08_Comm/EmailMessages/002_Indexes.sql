-- CREATE INDEX on a partitioned table propagates to every existing
-- partition and to every partition created later via PARTITION OF.
CREATE INDEX ix_email_messages_tenant ON comm.email_messages (tenant_id);

CREATE INDEX ix_email_messages_thread ON comm.email_messages (thread_id);

CREATE INDEX ix_email_messages_matter ON comm.email_messages (matter_id);

CREATE INDEX ix_email_messages_client ON comm.email_messages (client_id);

-- Explicit prompt requirement: UNIQUE(message_id_hdr) per partition
-- strategy note — see 001_Table.sql comment for why sent_at must also be
-- part of the key.
CREATE UNIQUE INDEX ux_email_messages_message_id_hdr ON comm.email_messages (message_id_hdr, sent_at);
