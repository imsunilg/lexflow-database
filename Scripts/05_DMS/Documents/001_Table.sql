-- PROMPT DB-5. PRD §18 (dms.documents(folder_id, matter_id, client_id,
-- case_id, title, doc_type, confidentiality, current_version_id,
-- portal_published)), Module 7.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- folder_id FK -> dms.folders(id) is forward (Folders sorts alphabetically
-- after Documents) — added in 05_DMS/Folders/003_Constraints.sql instead.
-- matter_id FK -> legal.matters(id), client_id FK -> crm.clients(id), case_id
-- FK -> legal.court_cases(id) are all backward-safe (04_Legal/03_CRM already
-- built) and added below.
-- current_version_id FK -> dms.document_versions(id) is backward-safe
-- (DocumentVersions sorts alphabetically before Documents) and added below;
-- kept in sync by the AFTER INSERT trigger on dms.document_versions
-- (05_DMS/DocumentVersions/004_Triggers.sql).
CREATE TABLE dms.documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  folder_id uuid,
  matter_id uuid,
  client_id uuid,
  case_id uuid,
  title text NOT NULL,
  doc_type text NOT NULL,
  confidentiality text NOT NULL DEFAULT 'Normal',
  current_version_id uuid,
  portal_published boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
