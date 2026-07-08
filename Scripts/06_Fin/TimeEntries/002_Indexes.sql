CREATE INDEX ix_time_entries_tenant ON fin.time_entries (tenant_id) WHERE is_deleted = false;

-- Explicit critical index from PRD §18: "CREATE INDEX ix_time_entries_tenant_user_date ON fin.time_entries(tenant_id, user_id, entry_date);".
CREATE INDEX ix_time_entries_tenant_user_date ON fin.time_entries (tenant_id, user_id, entry_date) WHERE is_deleted = false;

CREATE INDEX ix_time_entries_matter ON fin.time_entries (matter_id) WHERE is_deleted = false;

CREATE INDEX ix_time_entries_invoice_line ON fin.time_entries (invoice_line_id) WHERE is_deleted = false;

CREATE INDEX ix_time_entries_status ON fin.time_entries (tenant_id, status) WHERE is_deleted = false;
