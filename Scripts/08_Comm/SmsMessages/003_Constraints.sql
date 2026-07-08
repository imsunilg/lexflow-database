ALTER TABLE comm.sms_messages
  ADD CONSTRAINT ck_sms_messages_direction CHECK (direction IN ('Inbound', 'Outbound'));

ALTER TABLE comm.sms_messages
  ADD CONSTRAINT ck_sms_messages_status CHECK (status IN ('Queued', 'Sent', 'Delivered', 'Failed'));

ALTER TABLE comm.sms_messages
  ADD CONSTRAINT fk_sms_messages_client FOREIGN KEY (client_id) REFERENCES crm.clients (id);

ALTER TABLE comm.sms_messages
  ADD CONSTRAINT fk_sms_messages_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);
