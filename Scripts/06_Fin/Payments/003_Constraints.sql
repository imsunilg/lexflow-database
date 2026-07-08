ALTER TABLE fin.payments
  ADD CONSTRAINT ck_payments_mode CHECK (mode IN ('Gateway', 'Cash', 'Cheque', 'NEFT', 'UPI'));

ALTER TABLE fin.payments
  ADD CONSTRAINT ck_payments_status CHECK (status IN ('Pending', 'Cleared', 'Bounced', 'Refunded', 'Voided'));

ALTER TABLE fin.payments
  ADD CONSTRAINT ck_payments_amount_positive CHECK (amount > 0);

ALTER TABLE fin.payments
  ADD CONSTRAINT fk_payments_client FOREIGN KEY (client_id) REFERENCES crm.clients (id);

-- Forward-reference FK hoisted here: PaymentAllocations sorts alphabetically
-- before Payments (Build Playbook §1.1 per-object execution order), so
-- fin.payments doesn't exist yet when PaymentAllocations' own
-- 003_Constraints.sql would otherwise run.
ALTER TABLE fin.payment_allocations
  ADD CONSTRAINT fk_payment_allocations_payment FOREIGN KEY (payment_id) REFERENCES fin.payments (id);
