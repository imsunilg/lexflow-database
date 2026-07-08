CREATE INDEX ix_whatsapp_optins_tenant ON comm.whatsapp_optins (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_whatsapp_optins_client ON comm.whatsapp_optins (client_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_whatsapp_optins_client_phone ON comm.whatsapp_optins (client_id, phone_e164) WHERE is_deleted = false;
