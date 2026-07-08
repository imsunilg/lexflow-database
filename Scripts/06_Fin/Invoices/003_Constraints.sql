ALTER TABLE fin.invoices
  ADD CONSTRAINT ck_invoices_status CHECK (status IN ('Draft', 'Submitted', 'Approved', 'Rejected', 'Sent', 'PartiallyPaid', 'Paid', 'Overdue', 'Void'));

ALTER TABLE fin.invoices
  ADD CONSTRAINT ck_invoices_totals_nonnegative CHECK (sub_total >= 0 AND discount_total >= 0 AND tax_total >= 0 AND grand_total >= 0 AND amount_paid >= 0);

-- BR-4: void only permitted from a non-Draft, unpaid state (paid invoices
-- are corrected via credit note instead, per Module 8 validation rules).
ALTER TABLE fin.invoices
  ADD CONSTRAINT ck_invoices_void_reason_required CHECK (status <> 'Void' OR void_reason IS NOT NULL);

ALTER TABLE fin.invoices
  ADD CONSTRAINT fk_invoices_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

ALTER TABLE fin.invoices
  ADD CONSTRAINT fk_invoices_client FOREIGN KEY (client_id) REFERENCES crm.clients (id);

-- Forward-reference FKs hoisted here: CreditNotes, DunningEvents,
-- InvoiceLines, and InvoiceTaxes all sort alphabetically before Invoices
-- (Build Playbook §1.1 per-object execution order), so fin.invoices doesn't
-- exist yet when each of those objects' own 003_Constraints.sql would
-- otherwise run.
ALTER TABLE fin.credit_notes
  ADD CONSTRAINT fk_credit_notes_invoice FOREIGN KEY (invoice_id) REFERENCES fin.invoices (id);

ALTER TABLE fin.dunning_events
  ADD CONSTRAINT fk_dunning_events_invoice FOREIGN KEY (invoice_id) REFERENCES fin.invoices (id);

ALTER TABLE fin.invoice_lines
  ADD CONSTRAINT fk_invoice_lines_invoice FOREIGN KEY (invoice_id) REFERENCES fin.invoices (id);

ALTER TABLE fin.invoice_taxes
  ADD CONSTRAINT fk_invoice_taxes_invoice FOREIGN KEY (invoice_id) REFERENCES fin.invoices (id);
