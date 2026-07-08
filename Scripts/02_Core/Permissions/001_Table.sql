-- PROMPT DB-2. PRD §14, §18, §21 (permission format module.action.scope).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- The permission catalog itself is fixed/system-defined (not user-editable);
-- it is seeded per tenant in 16_Seed (001_Permissions_Catalog.sql) so that the
-- tenant_id NOT NULL convention still holds.
CREATE TABLE core.permissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  key text NOT NULL,
  module text NOT NULL,
  action text NOT NULL,
  scope text NOT NULL,
  label text,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
