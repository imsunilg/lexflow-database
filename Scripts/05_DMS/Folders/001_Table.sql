-- PROMPT DB-5. PRD §18 (dms.folders(parent_id, name, matter_id, path
-- ltree)), Module 7: "firm root → matter folders auto-created ... → user
-- folders/subfolders (depth ≤ 10)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- parent_id is self-referencing (added below — same-object self-reference,
-- no ordering issue).
-- matter_id FK -> legal.matters(id) is backward-safe (04_Legal already
-- built) and added below.
CREATE TABLE dms.folders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  parent_id uuid,
  name text NOT NULL,
  matter_id uuid,
  path ltree,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
