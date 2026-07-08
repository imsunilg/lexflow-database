ALTER TABLE dms.document_templates
  ADD CONSTRAINT ck_document_templates_version_positive CHECK (version > 0);
