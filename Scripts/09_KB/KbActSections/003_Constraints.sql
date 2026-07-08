ALTER TABLE kb.kb_act_sections
  ADD CONSTRAINT fk_kb_act_sections_parent FOREIGN KEY (parent_id) REFERENCES kb.kb_act_sections (id);

ALTER TABLE kb.kb_act_sections
  ADD CONSTRAINT ck_kb_act_sections_no_self_parent CHECK (parent_id IS NULL OR parent_id <> id);

ALTER TABLE kb.kb_act_sections
  ADD CONSTRAINT ck_kb_act_sections_effective_range CHECK (effective_to IS NULL OR effective_from IS NULL OR effective_to > effective_from);

-- fk_kb_act_sections_act is added in 09_KB/KbActs/003_Constraints.sql
-- instead — KbActs sorts alphabetically after KbActSections.
