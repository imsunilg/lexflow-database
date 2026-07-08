ALTER TABLE fin.invoice_taxes
  ADD CONSTRAINT ck_invoice_taxes_rate_nonnegative CHECK (rate_pct >= 0);

ALTER TABLE fin.invoice_taxes
  ADD CONSTRAINT ck_invoice_taxes_amount_nonnegative CHECK (amount >= 0);

-- fk_invoice_taxes_invoice is added in 06_Fin/Invoices/003_Constraints.sql
-- instead — Invoices sorts alphabetically after InvoiceTaxes.
