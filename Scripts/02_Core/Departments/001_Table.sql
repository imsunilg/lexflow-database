-- PROMPT DB-2. PRD §14, §18, Module 14 (Departments — org structure, reporting-manager chain).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- head_user_id: FK to core.users(id) added in 02_Core/Users/003_Constraints.sql,
-- not here — Users sorts alphabetically after Departments (Build Playbook §1.1
-- per-object execution order), so core.users doesn't exist yet at this point.
CREATE TABLE core.departments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  name text NOT NULL,
  code text,
  head_user_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
