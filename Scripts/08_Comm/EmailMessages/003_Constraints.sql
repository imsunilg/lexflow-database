ALTER TABLE comm.email_messages
  ADD CONSTRAINT ck_email_messages_direction CHECK (direction IN ('Inbound', 'Outbound'));

ALTER TABLE comm.email_messages
  ADD CONSTRAINT fk_email_messages_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

ALTER TABLE comm.email_messages
  ADD CONSTRAINT fk_email_messages_client FOREIGN KEY (client_id) REFERENCES crm.clients (id);

-- Forward-reference FK hoisted here: EmailAttachments sorts alphabetically
-- before EmailMessages (Build Playbook §1.1 per-object execution order), so
-- comm.email_messages doesn't exist yet when EmailAttachments' own
-- 003_Constraints.sql would otherwise run.
ALTER TABLE comm.email_attachments
  ADD CONSTRAINT fk_email_attachments_message FOREIGN KEY (message_id, message_sent_at) REFERENCES comm.email_messages (id, sent_at);
