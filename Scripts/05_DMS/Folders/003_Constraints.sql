ALTER TABLE dms.folders
  ADD CONSTRAINT fk_folders_parent FOREIGN KEY (parent_id) REFERENCES dms.folders (id);

ALTER TABLE dms.folders
  ADD CONSTRAINT ck_folders_no_self_parent CHECK (parent_id IS NULL OR parent_id <> id);

ALTER TABLE dms.folders
  ADD CONSTRAINT fk_folders_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

-- Forward-reference FK hoisted here: Documents sorts alphabetically before
-- Folders (Build Playbook §1.1 per-object execution order), so dms.folders
-- doesn't exist yet when Documents' own 003_Constraints.sql would otherwise
-- run.
ALTER TABLE dms.documents
  ADD CONSTRAINT fk_documents_folder FOREIGN KEY (folder_id) REFERENCES dms.folders (id);
