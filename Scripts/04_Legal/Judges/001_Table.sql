-- PROMPT DB-4. PRD §18 (legal.judges), Module 5 ("judge changed mid-case —
-- judge history kept for analytics" handled at the app layer via
-- court_cases.judge_id reassignment; this table is the judge roster itself).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- court_id FK -> legal.courts(id) is backward (Courts sorts before Judges)
-- and is added normally in this object's own 003_Constraints.sql.
CREATE TABLE legal.judges (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  name text NOT NULL,
  court_id uuid NOT NULL,
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
