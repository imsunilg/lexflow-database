-- Clients' own constraints.
ALTER TABLE crm.clients
  ADD CONSTRAINT ck_clients_type CHECK (type IN ('Individual', 'Corporate'));

ALTER TABLE crm.clients
  ADD CONSTRAINT ck_clients_status CHECK (status IN ('Active', 'Dormant', 'Deceased', 'Blocked'));

-- Module 3 validation: "Individual: first+last name required; Corporate: legal
-- name ... required" (the corporate "at least one contact person" half of this
-- rule spans client_contacts and is enforced at the application layer, not here).
ALTER TABLE crm.clients
  ADD CONSTRAINT ck_clients_name_by_type CHECK (
    (type = 'Individual' AND first_name IS NOT NULL)
    OR (type = 'Corporate' AND legal_name IS NOT NULL)
  );

ALTER TABLE crm.clients
  ADD CONSTRAINT fk_clients_owner FOREIGN KEY (owner_id) REFERENCES core.users (id);

ALTER TABLE crm.clients
  ADD CONSTRAINT fk_clients_branch FOREIGN KEY (branch_id) REFERENCES core.branches (id);

-- Forward-reference FKs hoisted here from other 03_CRM objects: DbUp applies
-- scripts in full relative-path order, and per-object folders execute
-- alphabetically (Build Playbook §1.1). "Clients" sorts alphabetically after
-- ClientAddresses, ClientContacts, ClientIdentityDocuments, ClientPortalUsers
-- and ClientRelationships, so each of those objects' FKs to crm.clients must
-- be added here instead of in their own 003_Constraints.sql, where
-- crm.clients would not exist yet. Same pattern as 02_Core/Users/003_Constraints.sql.
ALTER TABLE crm.client_addresses
  ADD CONSTRAINT fk_client_addresses_client FOREIGN KEY (client_id) REFERENCES crm.clients (id);

ALTER TABLE crm.client_contacts
  ADD CONSTRAINT fk_client_contacts_client FOREIGN KEY (client_id) REFERENCES crm.clients (id);

ALTER TABLE crm.client_identity_documents
  ADD CONSTRAINT fk_client_identity_documents_client FOREIGN KEY (client_id) REFERENCES crm.clients (id);

ALTER TABLE crm.client_portal_users
  ADD CONSTRAINT fk_client_portal_users_client FOREIGN KEY (client_id) REFERENCES crm.clients (id);

ALTER TABLE crm.client_relationships
  ADD CONSTRAINT fk_client_relationships_client FOREIGN KEY (client_id) REFERENCES crm.clients (id);

ALTER TABLE crm.client_relationships
  ADD CONSTRAINT fk_client_relationships_related_client FOREIGN KEY (related_client_id) REFERENCES crm.clients (id);

-- Deliberately NOT foreign-keyed: created_by/updated_by/deleted_by (soft
-- audit-actor references — see 02_Core/Users/003_Constraints.sql for why).
-- Also not FK'd yet: source_lead_id (added in 03_CRM/Leads/003_Constraints.sql,
-- Leads sorts after Clients). clients has no FK to legal.matters or fin.*
-- tables — those schemas don't exist yet (04_Legal/06_Fin build later); the
-- "block delete while matters reference this client" rule (this prompt) is
-- enforced by the 004_Triggers.sql trigger below, not a physical FK, since a
-- FK would require legal.matters to already exist.
