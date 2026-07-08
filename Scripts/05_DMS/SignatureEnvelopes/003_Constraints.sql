ALTER TABLE dms.signature_envelopes
  ADD CONSTRAINT ck_signature_envelopes_provider CHECK (provider IN ('DocuSign', 'AdobeSign'));

ALTER TABLE dms.signature_envelopes
  ADD CONSTRAINT ck_signature_envelopes_status CHECK (status IN ('Draft', 'Sent', 'Alerted', 'Completed', 'Declined', 'Voided'));

ALTER TABLE dms.signature_envelopes
  ADD CONSTRAINT fk_signature_envelopes_document FOREIGN KEY (document_id) REFERENCES dms.documents (id);

ALTER TABLE dms.signature_envelopes
  ADD CONSTRAINT fk_signature_envelopes_completed_doc_version FOREIGN KEY (completed_doc_version_id) REFERENCES dms.document_versions (id);
