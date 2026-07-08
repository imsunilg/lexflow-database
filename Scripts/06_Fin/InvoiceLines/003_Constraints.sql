ALTER TABLE fin.invoice_lines
  ADD CONSTRAINT ck_invoice_lines_type CHECK (type IN ('Time', 'Expense', 'Fixed', 'Retainer', 'Discount'));

ALTER TABLE fin.invoice_lines
  ADD CONSTRAINT ck_invoice_lines_qty_positive CHECK (qty > 0);

ALTER TABLE fin.invoice_lines
  ADD CONSTRAINT ck_invoice_lines_rate_nonnegative CHECK (rate >= 0);

-- fk_invoice_lines_invoice is added in 06_Fin/Invoices/003_Constraints.sql
-- instead — Invoices sorts alphabetically after InvoiceLines.
