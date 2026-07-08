ALTER TABLE legal.matter_important_dates
  ADD CONSTRAINT ck_matter_important_dates_kind CHECK (kind IN ('Limitation', 'Filing', 'Compliance', 'Custom'));

-- fk_matter_important_dates_matter is added in 04_Legal/Matters/003_Constraints.sql
-- instead of here — Matters sorts alphabetically after MatterImportantDates.
