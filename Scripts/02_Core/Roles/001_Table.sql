-- PROMPT DB-2. PRD §14, §18, §21 (roles/permissions matrix).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- System roles (Owner, Admin, Senior Partner, ...) are seeded per tenant in
-- 16_Seed with is_system = true; Enterprise custom roles are tenant-authored
-- with is_system = false (PRD Module 14).
CREATE TABLE core.roles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  key text NOT NULL,
  name text NOT NULL,
  is_system boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
