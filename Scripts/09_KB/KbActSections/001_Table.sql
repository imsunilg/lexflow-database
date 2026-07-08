-- PROMPT DB-9. PRD §18 (kb.kb_act_sections(act_id, parent_id, number,
-- title, body, effective_from, effective_to)), Module 12: "Acts (hierarchy:
-- Act → Chapter → Section → sub-section text)"; edge case: "Act amendments
-- (section versions with effective dates; reader shows as-on-date
-- selector)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- act_id FK -> kb.kb_acts(id) is forward (KbActs sorts alphabetically after
-- KbActSections) — added in 09_KB/KbActs/003_Constraints.sql instead.
-- parent_id is self-referencing (added below — same-object self-reference,
-- no ordering issue).
-- Explicit prompt requirement: path ltree column for fast subtree queries
-- (e.g. "all descendants of Chapter III" via path <@ '...'). Same
-- app-maintained convention as 05_DMS/Folders/001_Table.sql.path — no
-- auto-maintenance trigger; the application computes/updates path when it
-- writes parent_id.
CREATE TABLE kb.kb_act_sections (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  act_id uuid NOT NULL,
  parent_id uuid,
  number text NOT NULL,
  title text,
  body text,
  effective_from date,
  effective_to date,
  path ltree,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
