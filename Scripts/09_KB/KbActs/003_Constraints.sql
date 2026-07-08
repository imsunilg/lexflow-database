-- Forward-reference FK hoisted here: KbActSections sorts alphabetically
-- before KbActs (Build Playbook §1.1 per-object execution order), so
-- kb.kb_acts doesn't exist yet when KbActSections' own 003_Constraints.sql
-- would otherwise run.
ALTER TABLE kb.kb_act_sections
  ADD CONSTRAINT fk_kb_act_sections_act FOREIGN KEY (act_id) REFERENCES kb.kb_acts (id);
