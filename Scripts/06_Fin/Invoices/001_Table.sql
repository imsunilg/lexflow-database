-- PROMPT DB-6. PRD §18 (fin.invoices(number, series_id, matter_id,
-- client_id, status, issue_date, due_date, currency, sub_total,
-- discount_total, tax_total, grand_total, amount_paid, notes,
-- pdf_blob_path, sent_at, voided_at, void_reason)), Module 8.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- matter_id FK -> legal.matters(id), client_id FK -> crm.clients(id) are
-- backward-safe (04_Legal / 03_CRM already built) and added below.
-- series_id FK -> fin.number_series(id) is forward (NumberSeries sorts
-- alphabetically after Invoices) — added in
-- 06_Fin/NumberSeries/003_Constraints.sql instead.
CREATE TABLE fin.invoices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  number text NOT NULL,
  series_id uuid,
  matter_id uuid NOT NULL,
  client_id uuid NOT NULL,
  status text NOT NULL DEFAULT 'Draft',
  issue_date date,
  due_date date,
  currency text NOT NULL DEFAULT 'INR',
  sub_total numeric(18, 2) NOT NULL DEFAULT 0,
  discount_total numeric(18, 2) NOT NULL DEFAULT 0,
  tax_total numeric(18, 2) NOT NULL DEFAULT 0,
  grand_total numeric(18, 2) NOT NULL DEFAULT 0,
  amount_paid numeric(18, 2) NOT NULL DEFAULT 0,
  notes text,
  pdf_blob_path text,
  sent_at timestamptz,
  voided_at timestamptz,
  void_reason text,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
