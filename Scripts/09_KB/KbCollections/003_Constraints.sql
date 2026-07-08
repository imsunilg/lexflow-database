-- Forward-reference FK hoisted here: KbCollectionItems sorts alphabetically
-- before KbCollections (Build Playbook §1.1 per-object execution order), so
-- kb.kb_collections doesn't exist yet when KbCollectionItems' own
-- 003_Constraints.sql would otherwise run.
ALTER TABLE kb.kb_collection_items
  ADD CONSTRAINT fk_kb_collection_items_collection FOREIGN KEY (collection_id) REFERENCES kb.kb_collections (id);
