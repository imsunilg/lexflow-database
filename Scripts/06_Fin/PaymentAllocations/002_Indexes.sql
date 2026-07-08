CREATE INDEX ix_payment_allocations_tenant ON fin.payment_allocations (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_payment_allocations_payment ON fin.payment_allocations (payment_id) WHERE is_deleted = false;

CREATE INDEX ix_payment_allocations_invoice ON fin.payment_allocations (invoice_id) WHERE is_deleted = false;
