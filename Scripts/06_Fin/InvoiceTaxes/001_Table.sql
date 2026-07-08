-- PROMPT DB-6. PRD §18 (fin.invoice_taxes(invoice_id, name, rate_pct,
-- taxable_amount, amount)), Module 8: India GST CGST+SGST vs IGST by
-- place-of-supply; US none/state; generic VAT.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- invoice_id FK -> fin.invoices(id) is forward (Invoices sorts
-- alphabetically after InvoiceTaxes) — added in
-- 06_Fin/Invoices/003_Constraints.sql instead.
CREATE TABLE fin.invoice_taxes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  invoice_id uuid NOT NULL,
  name text NOT NULL,
  rate_pct numeric(6, 3) NOT NULL,
  taxable_amount numeric(18, 2) NOT NULL,
  amount numeric(18, 2) NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
