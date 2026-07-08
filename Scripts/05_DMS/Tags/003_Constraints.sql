-- Forward-reference FK hoisted here: DocumentTags sorts alphabetically
-- before Tags (Build Playbook §1.1 per-object execution order), so
-- dms.tags doesn't exist yet when DocumentTags' own 003_Constraints.sql
-- would otherwise run.
ALTER TABLE dms.document_tags
  ADD CONSTRAINT fk_document_tags_tag FOREIGN KEY (tag_id) REFERENCES dms.tags (id);
