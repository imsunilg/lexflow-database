-- PRD Module 13 Database: "report_runs." APIs: "POST /api/v1/reports/{key}/run
-- {params} -> jobId for heavy, inline for light · GET /api/v1/reports/runs/{jobId}".
-- Error Handling: "Run timeout 120 s -> auto-converts to async job with notify."
-- Security: "export audited with report key + row count."
--
-- One row per report execution, whether it resolved inline (Status goes
-- straight Running->Completed within the request) or was converted to a
-- Hangfire job (Status starts Queued, the worker flips it Running->
-- Completed/Failed). schedule_id references rpt.report_schedules, which
-- sorts alphabetically after this table (Build Playbook §1.1) — that FK is
-- hoisted into ReportSchedules/003_Constraints.sql.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- report_definition_id FK -> rpt.report_definitions(id) is backward-safe
-- (ReportDefinitions sorts before ReportRuns) and added below.
CREATE TABLE rpt.report_runs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  report_key text,
  report_definition_id uuid,
  schedule_id uuid,
  params_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  status text NOT NULL DEFAULT 'Queued',
  format text,
  row_count int,
  result_blob_path text,
  error_message text,
  requested_by uuid,
  requested_at timestamptz NOT NULL DEFAULT now(),
  started_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
