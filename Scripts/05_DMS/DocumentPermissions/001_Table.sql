-- PROMPT DB-5. PRD §18 (dms.document_permissions(document_id, principal_type,
-- principal_id, access)), Module 7.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- document_id FK -> dms.documents(id) is forward (Documents sorts
-- alphabetically after DocumentPermissions) — added in
-- 05_DMS/Documents/003_Constraints.sql instead.
-- principal_id is polymorphic (user/team/role/portal_client/link per
-- principal_type) so it is intentionally not FK'd to any single table.
CREATE TABLE dms.document_permissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  document_id uuid NOT NULL,
  principal_type text NOT NULL,
  principal_id uuid NOT NULL,
  access text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
