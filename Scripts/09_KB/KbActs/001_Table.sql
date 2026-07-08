-- PROMPT DB-9. PRD §18 (kb.kb_acts(name, short_code, jurisdiction, year)),
-- Module 12: "Acts (hierarchy: Act → Chapter → Section → sub-section
-- text)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- No forward-referencing FKs from this object.
CREATE TABLE kb.kb_acts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  name text NOT NULL,
  short_code text,
  jurisdiction text,
  year int,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
