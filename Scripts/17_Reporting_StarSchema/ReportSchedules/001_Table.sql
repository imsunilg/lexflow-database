-- PRD Module 13 Database: "report_schedules." Custom Report Builder:
-- "...schedule (email PDF/XLSX daily/weekly/monthly to recipients)."
-- Validation: "schedule recipients must be firm users or verified emails."
-- AC-R3: "scheduled report arrives within 15 min of schedule with correct
-- attachment."
--
-- recipients_json is a plain array of {userId} or {email} entries validated
-- at save time against core.users / verified-email rules in the application
-- layer (no DB-level enumeration of "verified emails" exists).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- report_definition_id FK -> rpt.report_definitions(id) is backward-safe.
CREATE TABLE rpt.report_schedules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  report_key text,
  report_definition_id uuid,
  frequency text NOT NULL,
  format text NOT NULL DEFAULT 'pdf',
  params_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  recipients_json jsonb NOT NULL DEFAULT '[]'::jsonb,
  next_run_at timestamptz,
  last_run_at timestamptz,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
