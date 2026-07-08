-- PROMPT DB-3. PRD §18 (crm.client_contacts), Module 3 (corporate contact persons).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- client_id FK: added in 03_CRM/Clients/003_Constraints.sql, not here —
-- Clients sorts alphabetically after ClientContacts (Build Playbook §1.1
-- per-object execution order), so crm.clients doesn't exist yet at this point.
CREATE TABLE crm.client_contacts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  client_id uuid NOT NULL,
  name text NOT NULL,
  designation text,
  email citext,
  phone text,
  is_primary boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
