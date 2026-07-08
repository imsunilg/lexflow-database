-- PROMPT DB-2. PRD §14, §18, §21, Module 14 AC-U3. Composite-PK join table
-- (user_id, role_id) per this prompt's explicit instruction — no surrogate uuid id.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
CREATE TABLE core.user_roles (
  tenant_id uuid NOT NULL,
  user_id uuid NOT NULL,
  role_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid,
  PRIMARY KEY (user_id, role_id)
);
