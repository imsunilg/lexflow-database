ALTER TABLE comm.comm_templates
  ADD CONSTRAINT ck_comm_templates_channel CHECK (channel IN ('Email', 'SMS', 'WhatsApp'));
