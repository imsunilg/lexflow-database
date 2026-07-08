-- PROMPT DB-6. PRD §18 (fin.trust_ledger_entries(trust_account_id,
-- entry_no bigserial, kind, amount, running_balance, purpose, invoice_id,
-- authorization_ref, approved_by, second_approver_id, reversal_of_id)),
-- Module 8 / BR-3: append-only, DB trigger blocks UPDATE/DELETE.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- trust_account_id FK -> fin.trust_accounts(id), invoice_id FK ->
-- fin.invoices(id), approved_by / second_approver_id FK -> core.users(id),
-- and reversal_of_id (self-FK) are all backward-safe and added below.
-- entry_no and running_balance are NOT set by the caller — the
-- 004_Triggers.sql BEFORE INSERT trigger computes both (entry_no as a
-- per-trust_account running sequence, running_balance as the post-entry
-- balance) while holding a row lock on the parent trust_accounts row.
CREATE TABLE fin.trust_ledger_entries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  trust_account_id uuid NOT NULL,
  entry_no bigint,
  kind text NOT NULL,
  amount numeric(18, 2) NOT NULL,
  running_balance numeric(18, 2),
  purpose text,
  invoice_id uuid,
  authorization_ref text,
  approved_by uuid,
  second_approver_id uuid,
  reversal_of_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
