ALTER TABLE kb.kb_collection_items
  ADD CONSTRAINT ck_kb_collection_items_ref_kind CHECK (kb_ref_kind IN ('Act', 'ActSection', 'Judgment', 'Article', 'Template'));

-- fk_kb_collection_items_collection is added in
-- 09_KB/KbCollections/003_Constraints.sql instead — KbCollections sorts
-- alphabetically after KbCollectionItems.
