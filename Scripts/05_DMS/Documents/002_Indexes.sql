CREATE INDEX ix_documents_tenant ON dms.documents (tenant_id) WHERE is_deleted = false;

-- Explicit critical index from PRD §18: "CREATE INDEX ix_docs_matter ON dms.documents(tenant_id, matter_id);".
CREATE INDEX ix_docs_matter ON dms.documents (tenant_id, matter_id) WHERE is_deleted = false;

CREATE INDEX ix_documents_folder ON dms.documents (folder_id) WHERE is_deleted = false;

CREATE INDEX ix_documents_client ON dms.documents (client_id) WHERE is_deleted = false;

CREATE INDEX ix_documents_case ON dms.documents (case_id) WHERE is_deleted = false;

-- Explicit prompt requirement: partial index on documents(confidentiality)
-- WHERE confidentiality='Privileged' to support the privileged-content
-- shield queries (AC-DOC3: privileged docs invisible in search without
-- permission) fast.
CREATE INDEX ix_documents_confidentiality_privileged ON dms.documents (confidentiality) WHERE confidentiality = 'Privileged';
