CREATE INDEX ix_rate_card_entries_tenant ON fin.rate_card_entries (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_rate_card_entries_card ON fin.rate_card_entries (rate_card_id) WHERE is_deleted = false;

CREATE INDEX ix_rate_card_entries_user ON fin.rate_card_entries (user_id) WHERE is_deleted = false;
