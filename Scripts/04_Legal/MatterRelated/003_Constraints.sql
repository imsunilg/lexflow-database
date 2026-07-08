ALTER TABLE legal.matter_related
  ADD CONSTRAINT ck_matter_related_type CHECK (relation_type IN ('Appeal-of', 'Connected', 'Cross-suit'));

ALTER TABLE legal.matter_related
  ADD CONSTRAINT ck_matter_related_no_self_loop CHECK (related_matter_id <> matter_id);

-- fk_matter_related_matter and fk_matter_related_related_matter are added in
-- 04_Legal/Matters/003_Constraints.sql instead of here — Matters sorts
-- alphabetically after MatterRelated.
