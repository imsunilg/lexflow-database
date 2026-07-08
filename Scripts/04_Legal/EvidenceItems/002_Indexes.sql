CREATE INDEX ix_evidence_items_tenant ON legal.evidence_items (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_evidence_items_case ON legal.evidence_items (case_id) WHERE is_deleted = false;
