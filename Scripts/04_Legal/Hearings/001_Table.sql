-- PROMPT DB-4. PRD §18 (legal.hearings), Module 5.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- case_id FK -> legal.court_cases(id) is backward (CourtCases sorts before
-- Hearings) and is added normally in this object's own 003_Constraints.sql.
-- assigned_lawyer_id FK -> core.users(id) is likewise backward-safe.
CREATE TABLE legal.hearings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  case_id uuid NOT NULL,
  date date NOT NULL,
  time time,
  court_tz text NOT NULL DEFAULT 'Asia/Kolkata',
  purpose text,
  courtroom text,
  assigned_lawyer_id uuid,
  status text NOT NULL DEFAULT 'Scheduled',
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
