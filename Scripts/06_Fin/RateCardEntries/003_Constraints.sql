ALTER TABLE fin.rate_card_entries
  ADD CONSTRAINT ck_rate_card_entries_rate_nonnegative CHECK (rate >= 0);

ALTER TABLE fin.rate_card_entries
  ADD CONSTRAINT ck_rate_card_entries_role_or_user CHECK (role IS NOT NULL OR user_id IS NOT NULL);

ALTER TABLE fin.rate_card_entries
  ADD CONSTRAINT fk_rate_card_entries_user FOREIGN KEY (user_id) REFERENCES core.users (id);

-- fk_rate_card_entries_rate_card is added in 06_Fin/RateCards/003_Constraints.sql
-- instead — RateCards sorts alphabetically after RateCardEntries.
