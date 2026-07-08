CREATE INDEX ix_kb_judgments_tenant ON kb.kb_judgments (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_kb_judgments_court ON kb.kb_judgments (court_id) WHERE is_deleted = false;

-- Explicit prompt requirement: kb_judgments UNIQUE(tenant_id, citation).
CREATE UNIQUE INDEX ux_kb_judgments_tenant_citation ON kb.kb_judgments (tenant_id, citation) WHERE is_deleted = false;
