-- PROMPT DB-14. PRD Module 2 (Lead Management): "mark Lost (mandatory
-- lost-reason from configurable list + free text)".
--
-- Same demo tenant id as 001–006.
WITH demo AS (
  SELECT '00000000-0000-0000-0000-000000000001'::uuid AS tenant_id
)
INSERT INTO crm.lost_reasons (tenant_id, name)
SELECT demo.tenant_id, v.name
FROM demo CROSS JOIN (VALUES
  ('Went with another firm'),
  ('Budget mismatch'),
  ('Handling in-house'),
  ('Not pursuing the matter'),
  ('Unresponsive'),
  ('Conflict of interest'),
  ('Out of practice area'),
  ('Duplicate/spam')
) AS v(name);
