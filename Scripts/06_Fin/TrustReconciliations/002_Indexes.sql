CREATE INDEX ix_trust_reconciliations_tenant ON fin.trust_reconciliations (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_trust_reconciliations_period ON fin.trust_reconciliations (tenant_id, period_end) WHERE is_deleted = false;
