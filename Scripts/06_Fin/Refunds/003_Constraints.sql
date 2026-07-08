ALTER TABLE fin.refunds
  ADD CONSTRAINT ck_refunds_status CHECK (status IN ('Requested', 'Processed', 'Failed'));

ALTER TABLE fin.refunds
  ADD CONSTRAINT ck_refunds_amount_positive CHECK (amount > 0);

ALTER TABLE fin.refunds
  ADD CONSTRAINT fk_refunds_payment FOREIGN KEY (payment_id) REFERENCES fin.payments (id);
