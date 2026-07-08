-- Enum values exactly as listed in PRD §18:
-- client_relationships(..., relation_type[Spouse|Child|Parent|ParentCompany|Subsidiary|Referrer|CoParty]).
ALTER TABLE crm.client_relationships
  ADD CONSTRAINT ck_client_relationships_type CHECK (
    relation_type IN ('Spouse', 'Child', 'Parent', 'ParentCompany', 'Subsidiary', 'Referrer', 'CoParty')
  );

-- The related party is either an actual client record (related_client_id) or
-- an external person not yet in the system (person_name) — PRD §18:
-- "related_client_id FK NULL, person_name".
ALTER TABLE crm.client_relationships
  ADD CONSTRAINT ck_client_relationships_related_or_person CHECK (
    related_client_id IS NOT NULL OR person_name IS NOT NULL
  );

ALTER TABLE crm.client_relationships
  ADD CONSTRAINT ck_client_relationships_no_self_loop CHECK (
    related_client_id IS NULL OR related_client_id <> client_id
  );

-- fk_client_relationships_client and fk_client_relationships_related_client
-- are added in 03_CRM/Clients/003_Constraints.sql instead of here — Clients
-- sorts alphabetically after ClientRelationships.
