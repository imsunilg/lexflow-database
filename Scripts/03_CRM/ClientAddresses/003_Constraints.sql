ALTER TABLE crm.client_addresses
  ADD CONSTRAINT ck_client_addresses_kind CHECK (kind IN ('Home', 'Office', 'Registered', 'Billing', 'Communication'));

-- fk_client_addresses_client is added in 03_CRM/Clients/003_Constraints.sql
-- instead of here — Clients sorts alphabetically after ClientAddresses.
