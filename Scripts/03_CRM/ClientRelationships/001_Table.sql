-- PROMPT DB-3. PRD §18 (crm.client_relationships), Module 3 ("Relationship
-- graph: family members ... corporate group linkage ... related clients").
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- client_id/related_client_id are both self-referencing FKs onto crm.clients
-- (the same table — client_id is the "owning" client, related_client_id is
-- the other party in the relationship, when that party is itself a client
-- record rather than an external person). Both FKs are added in
-- 03_CRM/Clients/003_Constraints.sql, not here — Clients sorts alphabetically
-- after ClientRelationships (Build Playbook §1.1 per-object execution order),
-- so crm.clients doesn't exist yet at this point.
CREATE TABLE crm.client_relationships (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  client_id uuid NOT NULL,
  related_client_id uuid,
  person_name text,
  relation_type text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
