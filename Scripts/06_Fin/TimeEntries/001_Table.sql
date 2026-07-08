-- PROMPT DB-6. PRD §18 (fin.time_entries(user_id, matter_id, activity_code_id,
-- entry_date, started_at, duration_min, rounded_min, billable, narrative,
-- internal_note, status, rate_snapshot, amount_snapshot, invoice_line_id,
-- source, approved_by, approved_at)), Module 9.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- user_id / approved_by FK -> core.users(id), matter_id FK ->
-- legal.matters(id), activity_code_id FK -> fin.activity_codes(id), and
-- invoice_line_id FK -> fin.invoice_lines(id) are all backward-safe
-- (ActivityCodes and InvoiceLines both sort before TimeEntries) and added
-- below.
CREATE TABLE fin.time_entries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  user_id uuid NOT NULL,
  matter_id uuid NOT NULL,
  activity_code_id uuid,
  entry_date date NOT NULL,
  started_at timestamptz,
  duration_min int NOT NULL,
  rounded_min int NOT NULL,
  billable boolean NOT NULL DEFAULT true,
  narrative text,
  internal_note text,
  status text NOT NULL DEFAULT 'Draft',
  rate_snapshot numeric(18, 4),
  amount_snapshot numeric(18, 2),
  invoice_line_id uuid,
  source text NOT NULL DEFAULT 'manual',
  approved_by uuid,
  approved_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
