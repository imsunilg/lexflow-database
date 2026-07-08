ALTER TABLE comm.whatsapp_optins
  ADD CONSTRAINT fk_whatsapp_optins_client FOREIGN KEY (client_id) REFERENCES crm.clients (id);
