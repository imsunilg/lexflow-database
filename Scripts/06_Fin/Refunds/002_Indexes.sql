CREATE INDEX ix_refunds_tenant ON fin.refunds (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_refunds_payment ON fin.refunds (payment_id) WHERE is_deleted = false;
