ALTER TABLE legal.matter_parties
  ADD CONSTRAINT ck_matter_parties_role CHECK (party_role IN ('Client', 'Opposite', 'Co-party', 'Witness-org'));

-- fk_matter_parties_matter is added in 04_Legal/Matters/003_Constraints.sql
-- instead of here — Matters sorts alphabetically after MatterParties.
