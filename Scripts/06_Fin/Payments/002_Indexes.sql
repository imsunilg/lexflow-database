CREATE INDEX ix_payments_tenant ON fin.payments (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_payments_client ON fin.payments (client_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_payments_tenant_receipt_number ON fin.payments (tenant_id, receipt_number) WHERE is_deleted = false;

-- Explicit prompt requirement: payments.idempotency_key UNIQUE(tenant_id, idempotency_key).
CREATE UNIQUE INDEX ux_payments_tenant_idempotency_key ON fin.payments (tenant_id, idempotency_key) WHERE idempotency_key IS NOT NULL;
