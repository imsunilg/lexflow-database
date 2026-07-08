ALTER TABLE legal.matter_expenses
  ADD CONSTRAINT ck_matter_expenses_amount_nonnegative CHECK (amount >= 0);

-- fk_matter_expenses_matter is added in 04_Legal/Matters/003_Constraints.sql
-- instead of here — Matters sorts alphabetically after MatterExpenses.
-- receipt_document_id is not FK'd yet (dms schema not built).
