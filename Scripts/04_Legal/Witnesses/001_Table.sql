-- PROMPT DB-4. PRD §18 (legal.witnesses), Module 5.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- case_id FK -> legal.court_cases(id) is backward (CourtCases sorts before
-- Witnesses) and is added normally in this object's own 003_Constraints.sql.
CREATE TABLE legal.witnesses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  case_id uuid NOT NULL,
  name text NOT NULL,
  side text,
  contact jsonb NOT NULL DEFAULT '{}'::jsonb,
  exam_status text NOT NULL DEFAULT 'ToBeExamined',
  scheduled_on date,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
