-- PROMPT DB-14. PRD Module 9 (Time Tracking): "activity code (configurable:
-- Drafting, Court Appearance, Research, Client Call, Review…)".
--
-- Same demo tenant id as 001/002/003/004.
WITH demo AS (
  SELECT '00000000-0000-0000-0000-000000000001'::uuid AS tenant_id
)
INSERT INTO fin.activity_codes (tenant_id, name, is_billable_default)
SELECT demo.tenant_id, v.name, v.is_billable_default
FROM demo CROSS JOIN (VALUES
  ('Drafting', true),
  ('Court Appearance', true),
  ('Research', true),
  ('Client Call', true),
  ('Review', true),
  ('Filing', true),
  ('Admin', false)
) AS v(name, is_billable_default);
