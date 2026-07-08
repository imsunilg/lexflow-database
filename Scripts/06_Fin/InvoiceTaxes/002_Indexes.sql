CREATE INDEX ix_invoice_taxes_tenant ON fin.invoice_taxes (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_invoice_taxes_invoice ON fin.invoice_taxes (invoice_id) WHERE is_deleted = false;
