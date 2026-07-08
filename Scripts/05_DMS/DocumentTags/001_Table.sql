-- PROMPT DB-5. PRD §18 (dms.document_tags join table), Module 7.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- document_id FK -> dms.documents(id) is forward (Documents sorts
-- alphabetically after DocumentTags) — added in
-- 05_DMS/Documents/003_Constraints.sql instead.
-- tag_id FK -> dms.tags(id) is forward (Tags sorts alphabetically after
-- DocumentTags) — added in 05_DMS/Tags/003_Constraints.sql instead.
CREATE TABLE dms.document_tags (
  tenant_id uuid NOT NULL,
  document_id uuid NOT NULL,
  tag_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid,
  PRIMARY KEY (document_id, tag_id)
);
