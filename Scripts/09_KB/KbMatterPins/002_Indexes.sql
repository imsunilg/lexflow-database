CREATE INDEX ix_kb_matter_pins_tenant ON kb.kb_matter_pins (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_kb_matter_pins_matter ON kb.kb_matter_pins (matter_id) WHERE is_deleted = false;
