ALTER TABLE dms.documents
  ADD CONSTRAINT ck_documents_doc_type CHECK (doc_type IN ('Pleading', 'Order', 'Agreement', 'Evidence', 'ID', 'Invoice', 'Other'));

ALTER TABLE dms.documents
  ADD CONSTRAINT ck_documents_confidentiality CHECK (confidentiality IN ('Normal', 'Confidential', 'Privileged'));

ALTER TABLE dms.documents
  ADD CONSTRAINT fk_documents_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

ALTER TABLE dms.documents
  ADD CONSTRAINT fk_documents_client FOREIGN KEY (client_id) REFERENCES crm.clients (id);

ALTER TABLE dms.documents
  ADD CONSTRAINT fk_documents_case FOREIGN KEY (case_id) REFERENCES legal.court_cases (id);

-- Explicit prompt requirement: "documents.current_version_id FK to
-- document_versions". Backward-safe — DocumentVersions sorts alphabetically
-- before Documents.
ALTER TABLE dms.documents
  ADD CONSTRAINT fk_documents_current_version FOREIGN KEY (current_version_id) REFERENCES dms.document_versions (id);

-- Forward-reference FKs hoisted here: DocumentActivity, DocumentPermissions,
-- DocumentShareLinks, DocumentTags, and DocumentVersions all sort
-- alphabetically before Documents (Build Playbook §1.1 per-object execution
-- order), so dms.documents doesn't exist yet when each of those objects'
-- own 003_Constraints.sql would otherwise run.
ALTER TABLE dms.document_activity
  ADD CONSTRAINT fk_document_activity_document FOREIGN KEY (document_id) REFERENCES dms.documents (id);

ALTER TABLE dms.document_permissions
  ADD CONSTRAINT fk_document_permissions_document FOREIGN KEY (document_id) REFERENCES dms.documents (id);

ALTER TABLE dms.document_share_links
  ADD CONSTRAINT fk_document_share_links_document FOREIGN KEY (document_id) REFERENCES dms.documents (id);

ALTER TABLE dms.document_tags
  ADD CONSTRAINT fk_document_tags_document FOREIGN KEY (document_id) REFERENCES dms.documents (id);

ALTER TABLE dms.document_versions
  ADD CONSTRAINT fk_document_versions_document FOREIGN KEY (document_id) REFERENCES dms.documents (id);

-- Deferred FKs from 03_CRM and 04_Legal, resolved now that dms.documents
-- exists: 05_DMS runs entirely after 03_CRM and 04_Legal in the top-level
-- numeric folder order (same pattern as fk_leads_practice_area resolved in
-- 04_Legal/PracticeAreas/003_Constraints.sql).
ALTER TABLE crm.client_identity_documents
  ADD CONSTRAINT fk_client_identity_documents_document FOREIGN KEY (document_id) REFERENCES dms.documents (id);

ALTER TABLE legal.court_orders
  ADD CONSTRAINT fk_court_orders_document FOREIGN KEY (document_id) REFERENCES dms.documents (id);

ALTER TABLE legal.evidence_items
  ADD CONSTRAINT fk_evidence_items_document FOREIGN KEY (document_id) REFERENCES dms.documents (id);

ALTER TABLE legal.matter_expenses
  ADD CONSTRAINT fk_matter_expenses_receipt_document FOREIGN KEY (receipt_document_id) REFERENCES dms.documents (id);
