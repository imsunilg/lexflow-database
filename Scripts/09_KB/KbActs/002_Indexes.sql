CREATE INDEX ix_kb_acts_tenant ON kb.kb_acts (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_kb_acts_tenant_short_code ON kb.kb_acts (tenant_id, short_code) WHERE is_deleted = false AND short_code IS NOT NULL;
