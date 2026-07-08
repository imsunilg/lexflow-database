-- PROMPT DB-6. PRD §18 (fin.payment_allocations(payment_id, invoice_id,
-- amount)), Module 8 / §19.8: "Payment ↔ Invoice: many-to-many through
-- allocations; over-allocation impossible (Σallocations ≤ payment.amount
-- and per-invoice Σ ≤ open balance, enforced in serializable transaction)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- invoice_id FK -> fin.invoices(id) is backward-safe (Invoices already
-- built) and added below.
-- payment_id FK -> fin.payments(id) is forward (Payments sorts
-- alphabetically after PaymentAllocations) — added in
-- 06_Fin/Payments/003_Constraints.sql instead.
CREATE TABLE fin.payment_allocations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  payment_id uuid NOT NULL,
  invoice_id uuid NOT NULL,
  amount numeric(18, 2) NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
