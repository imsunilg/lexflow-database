ALTER TABLE dms.document_versions
  ADD CONSTRAINT ck_document_versions_version_no_positive CHECK (version_no > 0);

ALTER TABLE dms.document_versions
  ADD CONSTRAINT ck_document_versions_size_nonnegative CHECK (size_bytes >= 0);

ALTER TABLE dms.document_versions
  ADD CONSTRAINT ck_document_versions_ocr_status CHECK (ocr_status IN ('NotApplicable', 'Pending', 'Processing', 'Done', 'Failed'));

ALTER TABLE dms.document_versions
  ADD CONSTRAINT fk_document_versions_uploaded_by FOREIGN KEY (uploaded_by) REFERENCES core.users (id);

-- fk_document_versions_document is added in 05_DMS/Documents/003_Constraints.sql
-- instead — Documents sorts alphabetically after DocumentVersions.
