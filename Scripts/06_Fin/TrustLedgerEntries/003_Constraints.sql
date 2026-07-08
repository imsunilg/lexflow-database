ALTER TABLE fin.trust_ledger_entries
  ADD CONSTRAINT ck_trust_ledger_entries_kind CHECK (kind IN ('Deposit', 'Disbursement', 'Reversal'));

ALTER TABLE fin.trust_ledger_entries
  ADD CONSTRAINT ck_trust_ledger_entries_amount_positive CHECK (amount > 0);

-- BR-3: a Reversal must always cite the entry it reverses.
ALTER TABLE fin.trust_ledger_entries
  ADD CONSTRAINT ck_trust_ledger_entries_reversal_requires_ref CHECK (kind <> 'Reversal' OR reversal_of_id IS NOT NULL);

ALTER TABLE fin.trust_ledger_entries
  ADD CONSTRAINT fk_trust_ledger_entries_account FOREIGN KEY (trust_account_id) REFERENCES fin.trust_accounts (id);

ALTER TABLE fin.trust_ledger_entries
  ADD CONSTRAINT fk_trust_ledger_entries_invoice FOREIGN KEY (invoice_id) REFERENCES fin.invoices (id);

ALTER TABLE fin.trust_ledger_entries
  ADD CONSTRAINT fk_trust_ledger_entries_approved_by FOREIGN KEY (approved_by) REFERENCES core.users (id);

ALTER TABLE fin.trust_ledger_entries
  ADD CONSTRAINT fk_trust_ledger_entries_second_approver FOREIGN KEY (second_approver_id) REFERENCES core.users (id);

ALTER TABLE fin.trust_ledger_entries
  ADD CONSTRAINT fk_trust_ledger_entries_reversal_of FOREIGN KEY (reversal_of_id) REFERENCES fin.trust_ledger_entries (id);
