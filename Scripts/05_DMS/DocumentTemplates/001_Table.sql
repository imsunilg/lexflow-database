-- PROMPT DB-5. PRD §18 (dms.document_templates), Module 7: "firm template
-- library (docx with merge fields {{client.name}}, {{matter.number}}...)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- No forward-referencing FKs from this object.
CREATE TABLE dms.document_templates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  name text NOT NULL,
  category text,
  docx_blob_path text NOT NULL,
  fields jsonb NOT NULL DEFAULT '{}'::jsonb,
  version int NOT NULL DEFAULT 1,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
