-- Forward-reference FK hoisted here: KbItemTags sorts alphabetically
-- before KbTags (Build Playbook §1.1 per-object execution order), so
-- kb.kb_tags doesn't exist yet when KbItemTags' own 003_Constraints.sql
-- would otherwise run.
ALTER TABLE kb.kb_item_tags
  ADD CONSTRAINT fk_kb_item_tags_tag FOREIGN KEY (tag_id) REFERENCES kb.kb_tags (id);
