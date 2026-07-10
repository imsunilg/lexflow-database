-- Module 17: "Cases/Matters: per matter: sanitized timeline (firm controls granularity:
-- hearings + published milestones only, or extended)." BR-10: "Nothing reaches the portal
-- without explicit publish flag ... internal notes and strategy classifications can never be
-- published." legal.hearings/legal.hearing_outcomes already exist (04_Legal sorts before
-- 19_Portal), so these are plain ALTER TABLE ADD COLUMN statements, not forward-reference
-- hoists. Default false: a hearing/outcome is invisible to the portal until a staff user
-- explicitly publishes it (deny-by-default, same posture as documents.portal_published).
ALTER TABLE legal.hearings ADD COLUMN portal_visible boolean NOT NULL DEFAULT false;
ALTER TABLE legal.hearing_outcomes ADD COLUMN portal_visible boolean NOT NULL DEFAULT false;
