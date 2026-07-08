CREATE INDEX ix_invoice_lines_tenant ON fin.invoice_lines (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_invoice_lines_invoice_line_no ON fin.invoice_lines (invoice_id, line_no) WHERE is_deleted = false;
