ALTER TABLE kb.kb_item_tags
  ADD CONSTRAINT ck_kb_item_tags_ref_kind CHECK (kb_ref_kind IN ('Act', 'ActSection', 'Judgment', 'Article', 'Template'));

-- fk_kb_item_tags_tag is added in 09_KB/KbTags/003_Constraints.sql instead
-- — KbTags sorts alphabetically after KbItemTags.
