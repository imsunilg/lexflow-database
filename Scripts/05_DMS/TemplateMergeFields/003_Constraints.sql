ALTER TABLE dms.template_merge_fields
  ADD CONSTRAINT fk_template_merge_fields_template FOREIGN KEY (template_id) REFERENCES dms.document_templates (id);
