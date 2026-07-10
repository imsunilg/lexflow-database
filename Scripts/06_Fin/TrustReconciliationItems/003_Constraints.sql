ALTER TABLE fin.trust_reconciliation_items
  ADD CONSTRAINT fk_trust_reconciliation_items_trust_account FOREIGN KEY (trust_account_id) REFERENCES fin.trust_accounts (id);

ALTER TABLE fin.trust_reconciliation_items
  ADD CONSTRAINT fk_trust_reconciliation_items_ledger_entry FOREIGN KEY (matched_ledger_entry_id) REFERENCES fin.trust_ledger_entries (id);

-- fk_trust_reconciliation_items_reconciliation is added in
-- 06_Fin/TrustReconciliations/003_Constraints.sql instead —
-- TrustReconciliations sorts alphabetically after TrustReconciliationItems.
