ALTER TABLE legal.practice_areas
  ADD CONSTRAINT fk_practice_areas_parent FOREIGN KEY (parent_id) REFERENCES legal.practice_areas (id);

ALTER TABLE legal.practice_areas
  ADD CONSTRAINT ck_practice_areas_no_self_parent CHECK (parent_id IS NULL OR parent_id <> id);

-- Forward-reference FK hoisted here: Matters sorts alphabetically before
-- PracticeAreas (Build Playbook §1.1 per-object execution order), so
-- legal.practice_areas doesn't exist yet when Matters' own
-- 003_Constraints.sql would otherwise run.
ALTER TABLE legal.matters
  ADD CONSTRAINT fk_matters_practice_area FOREIGN KEY (practice_area_id) REFERENCES legal.practice_areas (id);

-- Deferred FK from 03_CRM/Leads/001_Table.sql: 04_Legal runs entirely after
-- 03_CRM in the top-level numeric folder order, so crm.leads already exists
-- by this point — this is the one place in the whole migration where a
-- cross-schema forward reference resolves itself just by numeric folder
-- ordering, no same-folder hoisting trick needed.
ALTER TABLE crm.leads
  ADD CONSTRAINT fk_leads_practice_area FOREIGN KEY (practice_area_id) REFERENCES legal.practice_areas (id);
