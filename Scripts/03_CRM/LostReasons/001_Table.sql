-- PROMPT DB-3. PRD §18, Module 2 (lost requires mandatory reason from configurable list).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
CREATE TABLE crm.lost_reasons (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  name text NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
