ALTER TABLE fin.invoice_status_history
  ADD CONSTRAINT fk_invoice_status_history_invoice FOREIGN KEY (invoice_id) REFERENCES fin.invoices (id);

ALTER TABLE fin.invoice_status_history
  ADD CONSTRAINT fk_invoice_status_history_changed_by FOREIGN KEY (changed_by) REFERENCES core.users (id);
