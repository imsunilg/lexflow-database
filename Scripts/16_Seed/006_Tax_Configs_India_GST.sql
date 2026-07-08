-- PROMPT DB-14. PRD Module 8 (Billing): "per-firm config: India GST
-- (CGST+SGST vs IGST by place-of-supply, SAC 9982)". One starter GST
-- config a tenant clones/edits — branch_id NULL means it applies firm-wide
-- until a branch overrides it (fin.tax_configs UNIQUE is
-- (tenant_id, branch_id, country_code, tax_type), so a branch-specific row
-- can coexist alongside this one).
--
-- Same demo tenant id as 001–005.
WITH demo AS (
  SELECT '00000000-0000-0000-0000-000000000001'::uuid AS tenant_id
)
INSERT INTO fin.tax_configs (tenant_id, branch_id, country_code, tax_type, components, is_active)
SELECT demo.tenant_id, NULL, 'IN', 'GST',
  jsonb_build_object('CGST', 9, 'SGST', 9, 'IGST', 18, 'SAC', '9982'),
  true
FROM demo;
