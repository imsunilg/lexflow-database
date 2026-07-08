CREATE INDEX ix_trust_ledger_entries_tenant ON fin.trust_ledger_entries (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_trust_ledger_entries_account_entry_no ON fin.trust_ledger_entries (trust_account_id, entry_no) WHERE is_deleted = false;

CREATE INDEX ix_trust_ledger_entries_invoice ON fin.trust_ledger_entries (invoice_id) WHERE is_deleted = false;
