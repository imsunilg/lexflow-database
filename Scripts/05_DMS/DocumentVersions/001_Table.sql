-- PROMPT DB-5. PRD §18 (dms.document_versions(document_id, version_no,
-- blob_path, size_bytes, mime, hash_sha256, ocr_status, uploaded_by,
-- UNIQUE(document_id, version_no))), Module 7: versions are immutable,
-- "history never rewritten" (restore creates a new version copying the old).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- document_id FK -> dms.documents(id) is forward (Documents sorts
-- alphabetically after DocumentVersions) — added in
-- 05_DMS/Documents/003_Constraints.sql instead.
-- uploaded_by FK -> core.users(id) is backward-safe and added below.
CREATE TABLE dms.document_versions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  document_id uuid NOT NULL,
  version_no int NOT NULL,
  blob_path text NOT NULL,
  size_bytes bigint NOT NULL,
  mime text,
  hash_sha256 text NOT NULL,
  ocr_status text NOT NULL DEFAULT 'NotApplicable',
  text_extracted boolean NOT NULL DEFAULT false,
  uploaded_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
