ALTER TABLE comm.whatsapp_messages
  ADD CONSTRAINT ck_whatsapp_messages_direction CHECK (direction IN ('Inbound', 'Outbound'));

ALTER TABLE comm.whatsapp_messages
  ADD CONSTRAINT ck_whatsapp_messages_status CHECK (status IN ('Queued', 'Sent', 'Delivered', 'Read', 'Failed'));

ALTER TABLE comm.whatsapp_messages
  ADD CONSTRAINT fk_whatsapp_messages_client FOREIGN KEY (client_id) REFERENCES crm.clients (id);

ALTER TABLE comm.whatsapp_messages
  ADD CONSTRAINT fk_whatsapp_messages_template FOREIGN KEY (template_id) REFERENCES comm.comm_templates (id);

ALTER TABLE comm.whatsapp_messages
  ADD CONSTRAINT fk_whatsapp_messages_media_document FOREIGN KEY (media_document_id) REFERENCES dms.documents (id);
