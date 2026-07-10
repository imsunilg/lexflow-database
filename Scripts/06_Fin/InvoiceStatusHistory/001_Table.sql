-- PRD §18 (fin.invoice_status_history), Module 8: "Delivery... Approval...
-- audit trail complete Draft->Void" (AC-B5). One append-style row per status
-- transition (Draft->Submitted->Approved->Sent->PartiallyPaid->Paid/Overdue/
-- Void, or ->Rejected), independent of the fin.invoices row itself so the
-- full transition history survives even though the invoice row is mutated
-- in place for its current status.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- invoice_id FK -> fin.invoices(id), changed_by FK -> core.users(id) are
-- both backward-safe (Invoices and Users already built) and added below.
CREATE TABLE fin.invoice_status_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  invoice_id uuid NOT NULL,
  from_status text,
  to_status text NOT NULL,
  reason text,
  changed_by uuid,
  changed_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
