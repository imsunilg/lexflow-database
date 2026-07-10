-- PRD §18 (fin.trust_reconciliation_items), Module 8 / BR-3: reconciliation
-- workspace "import -> auto-match -> exceptions list -> sign-off". One row
-- per imported bank-statement line; matched_ledger_entry_id links it to the
-- fin.trust_ledger_entries row it was auto-matched (or manually matched) to,
-- and is_exception flags lines that could not be matched (surfaced in the
-- exceptions list).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- trust_account_id FK -> fin.trust_accounts(id), matched_ledger_entry_id FK
-- -> fin.trust_ledger_entries(id) are both backward-safe (already built) and
-- added below.
-- reconciliation_id FK -> fin.trust_reconciliations(id) is forward
-- (TrustReconciliations sorts alphabetically after TrustReconciliationItems)
-- — added in 06_Fin/TrustReconciliations/003_Constraints.sql instead.
CREATE TABLE fin.trust_reconciliation_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  reconciliation_id uuid NOT NULL,
  trust_account_id uuid,
  bank_line_date date NOT NULL,
  bank_line_description text,
  bank_line_amount numeric(18, 2) NOT NULL,
  matched_ledger_entry_id uuid,
  is_exception boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
