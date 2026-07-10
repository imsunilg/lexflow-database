CREATE INDEX ix_invoice_status_history_tenant ON fin.invoice_status_history (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_invoice_status_history_invoice ON fin.invoice_status_history (invoice_id, changed_at) WHERE is_deleted = false;
