-- PROMPT DB-4. PRD Module 5 (court holiday calendars — "next-hearing date on
-- a court holiday → warning with nearest working days").
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- court_id FK: added in 04_Legal/Courts/003_Constraints.sql, not here —
-- Courts sorts alphabetically after CourtHolidays (Build Playbook §1.1
-- per-object execution order), so legal.courts doesn't exist yet at this point.
CREATE TABLE legal.court_holidays (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  court_id uuid NOT NULL,
  holiday_date date NOT NULL,
  name text,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
