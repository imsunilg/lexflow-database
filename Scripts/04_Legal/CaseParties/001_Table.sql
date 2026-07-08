-- PROMPT DB-4. PRD Module 5 ("Parties: petitioner(s)/plaintiff, respondent(s)/
-- defendant, with advocates (own side = internal users; opposing = free-text
-- advocate registry entries)").
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- case_id FK: added in 04_Legal/CourtCases/003_Constraints.sql, not here —
-- CourtCases sorts alphabetically after CaseParties (Build Playbook §1.1
-- per-object execution order), so legal.court_cases doesn't exist yet here.
-- advocate_user_id FK -> core.users(id) is backward (02_Core already exists)
-- so it's added normally below, in this object's own 003_Constraints.sql.
CREATE TABLE legal.case_parties (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  case_id uuid NOT NULL,
  party_role text NOT NULL,
  name text NOT NULL,
  advocate_name text,
  advocate_user_id uuid,
  contact jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
