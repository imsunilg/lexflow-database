-- BR-3 Trust before operating / AC-B4: "Trust disbursement exceeding
-- balance is impossible via API, UI, and direct concurrent race
-- (serializable check proven by test)." This single BEFORE INSERT trigger:
--   1. Locks the parent trust_accounts row (SELECT ... FOR UPDATE) so
--      concurrent postings against the same account serialize instead of
--      racing on the balance check.
--   2. Assigns entry_no as a per-trust_account running sequence (a plain
--      bigserial can't reset per account, so it is computed here instead).
--   3. For Disbursement (and a Reversal-of-Deposit, which also removes
--      funds), raises INSUFFICIENT_TRUST_BALANCE if amount exceeds the
--      current balance.
--   4. Computes running_balance and writes the new balance back onto the
--      locked trust_accounts row.
CREATE OR REPLACE FUNCTION fin.trg_trust_ledger_entries_before_insert() RETURNS trigger AS $$
DECLARE
  v_balance numeric(18, 2);
  v_next_entry_no bigint;
  v_new_balance numeric(18, 2);
  v_reversed_kind text;
  v_removes_funds boolean;
BEGIN
  SELECT current_balance INTO v_balance
  FROM fin.trust_accounts
  WHERE id = NEW.trust_account_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Unknown trust_account %', NEW.trust_account_id;
  END IF;

  SELECT COALESCE(MAX(entry_no), 0) + 1 INTO v_next_entry_no
  FROM fin.trust_ledger_entries
  WHERE trust_account_id = NEW.trust_account_id;
  NEW.entry_no := v_next_entry_no;

  v_removes_funds := (NEW.kind = 'Disbursement');

  IF NEW.kind = 'Reversal' THEN
    SELECT kind INTO v_reversed_kind FROM fin.trust_ledger_entries WHERE id = NEW.reversal_of_id;
    -- Reversing a Deposit removes funds (same as a disbursement); reversing
    -- a Disbursement restores funds.
    v_removes_funds := (v_reversed_kind = 'Deposit');
  END IF;

  IF v_removes_funds THEN
    IF NEW.amount > v_balance THEN
      RAISE EXCEPTION 'INSUFFICIENT_TRUST_BALANCE: % of % exceeds trust_account % balance % (BR-3)', NEW.kind, NEW.amount, NEW.trust_account_id, v_balance;
    END IF;
    v_new_balance := v_balance - NEW.amount;
  ELSE
    v_new_balance := v_balance + NEW.amount;
  END IF;

  NEW.running_balance := v_new_balance;

  UPDATE fin.trust_accounts
  SET current_balance = v_new_balance, updated_at = now()
  WHERE id = NEW.trust_account_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_trust_ledger_entries_before_insert
  BEFORE INSERT ON fin.trust_ledger_entries
  FOR EACH ROW EXECUTE FUNCTION fin.trg_trust_ledger_entries_before_insert();

-- BR-3 / AC-B7: "Attempted UPDATE on trust_ledger_entries at DB level is
-- rejected by trigger." The ledger is fully append-only — corrections are
-- new Reversal rows, never edits to history.
CREATE OR REPLACE FUNCTION fin.trg_trust_ledger_entries_block_mutation() RETURNS trigger AS $$
BEGIN
  RAISE EXCEPTION 'trust_ledger_entries is append-only — % is not permitted (PRD §18 / BR-3 / AC-B7)', TG_OP;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_trust_ledger_entries_block_update
  BEFORE UPDATE ON fin.trust_ledger_entries
  FOR EACH ROW EXECUTE FUNCTION fin.trg_trust_ledger_entries_block_mutation();

CREATE TRIGGER trg_trust_ledger_entries_block_delete
  BEFORE DELETE ON fin.trust_ledger_entries
  FOR EACH ROW EXECUTE FUNCTION fin.trg_trust_ledger_entries_block_mutation();
