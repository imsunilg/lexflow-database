-- PROMPT DB-14. PRD Module 5 (Litigation): courts/judges reference data.
-- Supreme Court + all 25 High Courts (post Jammu & Kashmir
-- reorganization/Ladakh split) + a handful of representative District
-- Courts + the common all-India tribunal types
-- (NCLT/NCLAT/ITAT/CAT/Consumer/Family/Labour) as starter reference data —
-- a real tenant onboarding would add their specific district/tribunal
-- benches; this seeds the well-known, stable national-level courts every
-- Indian tenant needs on day one.
--
-- Same demo tenant id as 001/002 — see 001_Permissions_Catalog.sql header
-- comment for why seeding against a not-yet-created tenant row is safe.
--
-- level values are constrained by ck_courts_level to
-- Supreme/High/District/Tribunal/Consumer/Other. Family Court is seeded as
-- Tribunal per this prompt's explicit grouping ("NCLT/NCLAT/ITAT/CAT/
-- Consumer/Family/Labour tribunal types"), even though in practice Family
-- Courts sit at district level — tenants can reclassify if desired.
WITH demo AS (
  SELECT '00000000-0000-0000-0000-000000000001'::uuid AS tenant_id
)
INSERT INTO legal.courts (tenant_id, name, level, city, state)
SELECT demo.tenant_id, v.name, v.level, v.city, v.state
FROM demo CROSS JOIN (VALUES
  -- Supreme Court
  ('Supreme Court of India', 'Supreme', 'New Delhi', 'Delhi'),

  -- 25 High Courts
  ('Allahabad High Court', 'High', 'Prayagraj', 'Uttar Pradesh'),
  ('Andhra Pradesh High Court', 'High', 'Amaravati', 'Andhra Pradesh'),
  ('Bombay High Court', 'High', 'Mumbai', 'Maharashtra'),
  ('Calcutta High Court', 'High', 'Kolkata', 'West Bengal'),
  ('Chhattisgarh High Court', 'High', 'Bilaspur', 'Chhattisgarh'),
  ('Delhi High Court', 'High', 'New Delhi', 'Delhi'),
  ('Gauhati High Court', 'High', 'Guwahati', 'Assam'),
  ('Gujarat High Court', 'High', 'Ahmedabad', 'Gujarat'),
  ('Himachal Pradesh High Court', 'High', 'Shimla', 'Himachal Pradesh'),
  ('High Court of Jammu & Kashmir and Ladakh', 'High', 'Srinagar', 'Jammu and Kashmir'),
  ('Jharkhand High Court', 'High', 'Ranchi', 'Jharkhand'),
  ('Karnataka High Court', 'High', 'Bengaluru', 'Karnataka'),
  ('Kerala High Court', 'High', 'Kochi', 'Kerala'),
  ('Madhya Pradesh High Court', 'High', 'Jabalpur', 'Madhya Pradesh'),
  ('Madras High Court', 'High', 'Chennai', 'Tamil Nadu'),
  ('Manipur High Court', 'High', 'Imphal', 'Manipur'),
  ('Meghalaya High Court', 'High', 'Shillong', 'Meghalaya'),
  ('Orissa High Court', 'High', 'Cuttack', 'Odisha'),
  ('Patna High Court', 'High', 'Patna', 'Bihar'),
  ('Punjab and Haryana High Court', 'High', 'Chandigarh', 'Punjab'),
  ('Rajasthan High Court', 'High', 'Jodhpur', 'Rajasthan'),
  ('Sikkim High Court', 'High', 'Gangtok', 'Sikkim'),
  ('Telangana High Court', 'High', 'Hyderabad', 'Telangana'),
  ('Tripura High Court', 'High', 'Agartala', 'Tripura'),
  ('Uttarakhand High Court', 'High', 'Nainital', 'Uttarakhand'),

  -- Sample District Courts
  ('Delhi District Court (Saket)', 'District', 'New Delhi', 'Delhi'),
  ('Mumbai City Civil Court', 'District', 'Mumbai', 'Maharashtra'),
  ('Bengaluru City Civil Court', 'District', 'Bengaluru', 'Karnataka'),
  ('Chennai City Civil Court', 'District', 'Chennai', 'Tamil Nadu'),
  ('Pune District Court', 'District', 'Pune', 'Maharashtra'),

  -- All-India tribunal types
  ('National Company Law Tribunal (NCLT)', 'Tribunal', 'New Delhi', 'Delhi'),
  ('National Company Law Appellate Tribunal (NCLAT)', 'Tribunal', 'New Delhi', 'Delhi'),
  ('Income Tax Appellate Tribunal (ITAT)', 'Tribunal', 'New Delhi', 'Delhi'),
  ('Central Administrative Tribunal (CAT)', 'Tribunal', 'New Delhi', 'Delhi'),
  ('Labour Court', 'Tribunal', 'New Delhi', 'Delhi'),
  ('Family Court', 'Tribunal', 'New Delhi', 'Delhi'),
  ('National Consumer Disputes Redressal Commission (NCDRC)', 'Consumer', 'New Delhi', 'Delhi')
) AS v(name, level, city, state);
