-- PROMPT DB-6. PRD §18 (fin.credit_notes(number, invoice_id FK, amount,
-- reason, status)), Module 8: corrections to sent/immutable invoices go
-- via credit note + reissue (BR-4).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- invoice_id FK -> fin.invoices(id) is forward (Invoices sorts
-- alphabetically after CreditNotes) — added in
-- 06_Fin/Invoices/003_Constraints.sql instead.
CREATE TABLE fin.credit_notes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  number text NOT NULL,
  invoice_id uuid NOT NULL,
  amount numeric(18, 2) NOT NULL,
  reason text NOT NULL,
  status text NOT NULL DEFAULT 'Draft',
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
