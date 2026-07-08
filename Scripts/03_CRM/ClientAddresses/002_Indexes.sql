CREATE INDEX ix_client_addresses_tenant ON crm.client_addresses (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_client_addresses_client ON crm.client_addresses (client_id) WHERE is_deleted = false;

-- Module 3 validation: "one primary address per type".
CREATE UNIQUE INDEX ux_client_addresses_primary_per_kind ON crm.client_addresses (client_id, kind)
  WHERE is_primary_of_kind = true AND is_deleted = false;
