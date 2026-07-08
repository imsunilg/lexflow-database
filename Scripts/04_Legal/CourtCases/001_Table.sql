-- PROMPT DB-4. PRD §18 (legal.court_cases), Module 5.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- court_id FK: added in 04_Legal/Courts/003_Constraints.sql — Courts sorts
-- alphabetically after CourtCases (Build Playbook §1.1 per-object execution
-- order), so legal.courts doesn't exist yet at this point.
-- judge_id FK: added in 04_Legal/Judges/003_Constraints.sql, same reason.
-- matter_id FK: added in 04_Legal/Matters/003_Constraints.sql, same reason.
-- appeal_of_case_id is self-referencing (added in this object's own
-- 003_Constraints.sql — no ordering issue, legal.court_cases already exists
-- from this file).
CREATE TABLE legal.court_cases (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  matter_id uuid NOT NULL,
  court_id uuid NOT NULL,
  case_type text NOT NULL,
  case_number text NOT NULL,
  case_year int NOT NULL,
  cnr_number text,
  filing_date date,
  stage text,
  judge_id uuid,
  courtroom text,
  status text NOT NULL DEFAULT 'Active',
  appeal_of_case_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
