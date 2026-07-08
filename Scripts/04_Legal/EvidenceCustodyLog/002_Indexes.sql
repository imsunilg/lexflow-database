CREATE INDEX ix_evidence_custody_log_tenant ON legal.evidence_custody_log (tenant_id);

CREATE INDEX ix_evidence_custody_log_evidence_at ON legal.evidence_custody_log (evidence_id, at DESC);
