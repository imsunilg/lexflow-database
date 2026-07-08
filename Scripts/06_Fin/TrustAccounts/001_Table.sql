-- PROMPT DB-6. PRD §18 (fin.trust_accounts(id, client_id FK UNIQUE,
-- bank_ref)), Module 8 / BR-3: "separate trust ledger per client... Balance
-- ≥ 0 enforced at DB."
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- client_id FK -> crm.clients(id) is backward-safe (03_CRM already built)
-- and added below.
-- current_balance is a denormalized running-total cache: it is the row the
-- 06_Fin/TrustLedgerEntries/004_Triggers.sql BEFORE INSERT trigger locks
-- (SELECT ... FOR UPDATE) to serialize concurrent postings and to read/write
-- the balance atomically for the INSUFFICIENT_TRUST_BALANCE check (BR-3).
CREATE TABLE fin.trust_accounts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  client_id uuid NOT NULL,
  bank_ref text,
  current_balance numeric(18, 2) NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
