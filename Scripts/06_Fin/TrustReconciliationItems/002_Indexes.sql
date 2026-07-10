CREATE INDEX ix_trust_reconciliation_items_tenant ON fin.trust_reconciliation_items (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_trust_reconciliation_items_reconciliation ON fin.trust_reconciliation_items (reconciliation_id) WHERE is_deleted = false;

CREATE INDEX ix_trust_reconciliation_items_exceptions ON fin.trust_reconciliation_items (reconciliation_id) WHERE is_exception = true AND is_deleted = false;
