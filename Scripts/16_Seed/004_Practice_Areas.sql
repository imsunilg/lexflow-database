-- PROMPT DB-14. PRD Module 4: "practice area (configurable tree: Civil,
-- Criminal, Corporate, Family, IP, Tax, Labour, Real Estate…)". Starter
-- flat list a tenant can reparent/extend — legal.practice_areas already
-- supports a self-referencing tree (parent_id) but a starter seed doesn't
-- need to pre-guess each firm's sub-area taxonomy.
--
-- Same demo tenant id as 001/002/003.
WITH demo AS (
  SELECT '00000000-0000-0000-0000-000000000001'::uuid AS tenant_id
)
INSERT INTO legal.practice_areas (tenant_id, name)
SELECT demo.tenant_id, v.name
FROM demo CROSS JOIN (VALUES
  ('Civil'),
  ('Criminal'),
  ('Corporate'),
  ('Family'),
  ('IP'),
  ('Tax'),
  ('Labour'),
  ('Real Estate'),
  ('Arbitration'),
  ('Compliance')
) AS v(name);
