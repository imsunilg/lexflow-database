-- PROMPT DB-6. PRD §18 (fin.invoice_lines(invoice_id, line_no, type,
-- description, qty, unit, rate, amount, time_entry_ids uuid[],
-- expense_ids uuid[])), Module 8.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- invoice_id FK -> fin.invoices(id) is forward (Invoices sorts
-- alphabetically after InvoiceLines) — added in
-- 06_Fin/Invoices/003_Constraints.sql instead.
-- time_entry_ids / expense_ids are plain uuid[] link arrays per §18 (not
-- FK'd — Postgres cannot FK an array column).
CREATE TABLE fin.invoice_lines (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  invoice_id uuid NOT NULL,
  line_no int NOT NULL,
  type text NOT NULL,
  description text,
  qty numeric(12, 2) NOT NULL DEFAULT 1,
  unit text,
  rate numeric(18, 4) NOT NULL DEFAULT 0,
  amount numeric(18, 2) NOT NULL DEFAULT 0,
  time_entry_ids uuid[] NOT NULL DEFAULT '{}',
  expense_ids uuid[] NOT NULL DEFAULT '{}',
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
