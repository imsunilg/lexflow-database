ALTER TABLE crm.client_portal_users
  ADD CONSTRAINT ck_client_portal_users_status CHECK (status IN ('Invited', 'Active', 'Suspended', 'Deactivated'));

-- fk_client_portal_users_client is added in 03_CRM/Clients/003_Constraints.sql
-- instead of here — Clients sorts alphabetically after ClientPortalUsers.
