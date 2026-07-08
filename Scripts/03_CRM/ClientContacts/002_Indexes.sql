CREATE INDEX ix_client_contacts_tenant ON crm.client_contacts (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_client_contacts_client ON crm.client_contacts (client_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_client_contacts_primary ON crm.client_contacts (client_id)
  WHERE is_primary = true AND is_deleted = false;
