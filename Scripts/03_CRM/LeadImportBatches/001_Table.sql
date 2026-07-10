-- Additive to 03_CRM, added after DB-3 had already been applied (DbUp journals
-- by script name, not content hash). PRD Module 2 lists lead_import_batches/
-- lead_import_rows as tables; this build collapses per-row tracking into the
-- generated error CSV (blob_path below) rather than a separate lead_import_rows
-- table, since no API in Module 2's own "APIs" list exposes per-row detail
-- beyond the downloadable error CSV (Error Handling: "invalid rows returned as
-- downloadable error CSV").
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
CREATE TABLE crm.lead_import_batches (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  file_name text NOT NULL,
  source_blob_path text NOT NULL,
  status text NOT NULL DEFAULT 'Pending',
  total_rows int NOT NULL DEFAULT 0,
  success_count int NOT NULL DEFAULT 0,
  error_count int NOT NULL DEFAULT 0,
  error_file_blob_path text,
  started_at timestamptz,
  completed_at timestamptz,
  failure_reason text,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
