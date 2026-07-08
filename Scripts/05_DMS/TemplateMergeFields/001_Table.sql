-- PROMPT DB-5. PRD §18 / Module 7 (template_merge_fields): "docx with merge
-- fields {{client.name}}, {{matter.number}}, {{court.name}},
-- {{hearing.next_date}}..." — "template merge fails on missing required
-- fields with field list".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- template_id FK -> dms.document_templates(id) is backward-safe
-- (DocumentTemplates already built) and added below.
CREATE TABLE dms.template_merge_fields (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  template_id uuid NOT NULL,
  field_key text NOT NULL,
  label text,
  required boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
