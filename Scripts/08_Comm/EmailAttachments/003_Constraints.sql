ALTER TABLE comm.email_attachments
  ADD CONSTRAINT fk_email_attachments_document FOREIGN KEY (document_id) REFERENCES dms.documents (id);

-- fk_email_attachments_message is added in
-- 08_Comm/EmailMessages/003_Constraints.sql instead — EmailMessages sorts
-- alphabetically after EmailAttachments.
