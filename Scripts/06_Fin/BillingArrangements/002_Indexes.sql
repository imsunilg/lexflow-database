CREATE INDEX ix_billing_arrangements_tenant ON fin.billing_arrangements (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_billing_arrangements_matter ON fin.billing_arrangements (matter_id) WHERE is_deleted = false;

CREATE INDEX ix_billing_arrangements_rate_card ON fin.billing_arrangements (rate_card_id) WHERE is_deleted = false;
