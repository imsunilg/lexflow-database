-- PRD §18 (fin.trust_reconciliations), Module 8 / BR-3: "monthly three-way
-- reconciliation (bank statement import CSV vs ledger vs client balances)
-- with sign-off." One row per reconciliation run (firm-wide across every
-- fin.trust_accounts row, not per-account — the three-way check is between
-- the imported bank statement total, the sum of all trust_accounts.current_
-- balance, and the sum of client-reported balances, all as of period_end).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- signed_off_by FK -> core.users(id) is backward-safe (02_Core already
-- built) and added below.
CREATE TABLE fin.trust_reconciliations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  period_start date NOT NULL,
  period_end date NOT NULL,
  bank_statement_balance numeric(18, 2) NOT NULL,
  ledger_balance numeric(18, 2) NOT NULL,
  status text NOT NULL DEFAULT 'Draft',
  imported_csv_blob_path text,
  notes text,
  signed_off_by uuid,
  signed_off_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
