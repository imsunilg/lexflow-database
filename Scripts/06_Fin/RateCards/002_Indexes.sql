CREATE INDEX ix_rate_cards_tenant ON fin.rate_cards (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_rate_cards_tenant_name ON fin.rate_cards (tenant_id, name) WHERE is_deleted = false;
