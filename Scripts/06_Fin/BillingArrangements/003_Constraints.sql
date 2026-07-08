ALTER TABLE fin.billing_arrangements
  ADD CONSTRAINT ck_billing_arrangements_type CHECK (arrangement_type IN ('Hourly', 'Fixed', 'Retainer', 'Contingency', 'ProBono'));

ALTER TABLE fin.billing_arrangements
  ADD CONSTRAINT ck_billing_arrangements_contingency_pct CHECK (contingency_pct IS NULL OR (contingency_pct > 0 AND contingency_pct <= 100));

ALTER TABLE fin.billing_arrangements
  ADD CONSTRAINT fk_billing_arrangements_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

-- fk_billing_arrangements_rate_card is added in
-- 06_Fin/RateCards/003_Constraints.sql instead — RateCards sorts
-- alphabetically after BillingArrangements.
