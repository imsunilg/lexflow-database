CREATE INDEX ix_credit_notes_tenant ON fin.credit_notes (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_credit_notes_invoice ON fin.credit_notes (invoice_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_credit_notes_tenant_number ON fin.credit_notes (tenant_id, number) WHERE is_deleted = false;
