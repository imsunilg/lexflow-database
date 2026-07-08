ALTER TABLE fin.payment_allocations
  ADD CONSTRAINT ck_payment_allocations_amount_positive CHECK (amount > 0);

ALTER TABLE fin.payment_allocations
  ADD CONSTRAINT fk_payment_allocations_invoice FOREIGN KEY (invoice_id) REFERENCES fin.invoices (id);

-- fk_payment_allocations_payment is added in 06_Fin/Payments/003_Constraints.sql
-- instead — Payments sorts alphabetically after PaymentAllocations.
