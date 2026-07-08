ALTER TABLE kb.kb_judgments
  ADD CONSTRAINT fk_kb_judgments_court FOREIGN KEY (court_id) REFERENCES legal.courts (id);

ALTER TABLE kb.kb_judgments
  ADD CONSTRAINT fk_kb_judgments_document FOREIGN KEY (document_id) REFERENCES dms.documents (id);
