-- PROMPT DB-3. PRD §18, Module 3, Module 17 ("separate identity realm" — this
-- is the core account row; portal_sessions/portal_messages etc. are built
-- alongside their own modules later).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- client_id FK: added in 03_CRM/Clients/003_Constraints.sql, not here —
-- Clients sorts alphabetically after ClientPortalUsers (Build Playbook §1.1
-- per-object execution order), so crm.clients doesn't exist yet at this point.
-- visible_matter_ids: NULL means "all matters visible" (default for an
-- individual client's sole login); a non-null array scopes a corporate
-- client's per-user matter visibility (Module 17: "corporate: several logins
-- per client, each with matter-visibility subset").
CREATE TABLE crm.client_portal_users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  client_id uuid NOT NULL,
  email citext NOT NULL,
  password_hash text,
  name text,
  status text NOT NULL DEFAULT 'Invited',
  two_fa_enabled boolean NOT NULL DEFAULT false,
  visible_matter_ids uuid[],
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
