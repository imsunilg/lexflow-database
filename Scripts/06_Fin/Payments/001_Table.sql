-- PROMPT DB-6. PRD §18 (fin.payments(receipt_number, client_id, amount,
-- mode, gateway, gateway_ref, received_on, status, idempotency_key
-- UNIQUE(tenant_id, idempotency_key))), Module 8.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- client_id FK -> crm.clients(id) is backward-safe (03_CRM already built)
-- and added below.
CREATE TABLE fin.payments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  receipt_number text NOT NULL,
  client_id uuid NOT NULL,
  amount numeric(18, 2) NOT NULL,
  mode text NOT NULL,
  gateway text,
  gateway_ref text,
  received_on date NOT NULL DEFAULT current_date,
  status text NOT NULL DEFAULT 'Pending',
  idempotency_key text,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
