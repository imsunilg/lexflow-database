ALTER TABLE dms.document_activity
  ADD CONSTRAINT ck_document_activity_action CHECK (action IN ('View', 'Download', 'Print', 'Edit', 'Share', 'Delete', 'Upload', 'Restore'));

ALTER TABLE dms.document_activity
  ADD CONSTRAINT fk_document_activity_user FOREIGN KEY (user_id) REFERENCES core.users (id);

-- fk_document_activity_document is added in 05_DMS/Documents/003_Constraints.sql
-- instead — Documents sorts alphabetically after DocumentActivity.
