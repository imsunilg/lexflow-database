-- PROMPT DB-4. PRD Module 5 ("Arguments notes: rich-text per hearing/stage;
-- citations linked to Knowledge Base judgments").
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- case_id FK: added in 04_Legal/CourtCases/003_Constraints.sql — CourtCases
-- sorts alphabetically after ArgumentNotes (Build Playbook §1.1 per-object
-- execution order), so legal.court_cases doesn't exist yet at this point.
-- hearing_id FK: added in 04_Legal/Hearings/003_Constraints.sql, same reason.
-- citation_judgment_ids: no FK — kb schema (09_KB) is built much later; these
-- are plain uuid references to kb.kb_judgments(id), resolved at the app layer.
CREATE TABLE legal.argument_notes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  case_id uuid NOT NULL,
  hearing_id uuid,
  stage text,
  body text NOT NULL,
  citation_judgment_ids uuid[],
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
