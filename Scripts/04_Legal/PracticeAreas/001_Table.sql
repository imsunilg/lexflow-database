-- PROMPT DB-4. PRD Module 4 ("practice area (configurable tree: Civil,
-- Criminal, Corporate, Family, IP, Tax, Labour, Real Estate…)").
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- parent_id is self-referencing (added below — same-object self-reference,
-- no ordering issue).
CREATE TABLE legal.practice_areas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  name text NOT NULL,
  parent_id uuid,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
