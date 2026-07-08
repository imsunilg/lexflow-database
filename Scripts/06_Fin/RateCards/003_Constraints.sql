ALTER TABLE fin.rate_cards
  ADD CONSTRAINT fk_rate_cards_branch FOREIGN KEY (branch_id) REFERENCES core.branches (id);

-- Forward-reference FKs hoisted here: BillingArrangements and
-- RateCardEntries both sort alphabetically before RateCards (Build
-- Playbook §1.1 per-object execution order), so fin.rate_cards doesn't
-- exist yet when either of those objects' own 003_Constraints.sql would
-- otherwise run.
ALTER TABLE fin.billing_arrangements
  ADD CONSTRAINT fk_billing_arrangements_rate_card FOREIGN KEY (rate_card_id) REFERENCES fin.rate_cards (id);

ALTER TABLE fin.rate_card_entries
  ADD CONSTRAINT fk_rate_card_entries_rate_card FOREIGN KEY (rate_card_id) REFERENCES fin.rate_cards (id);
