ALTER TABLE fin.credit_notes
  ADD CONSTRAINT ck_credit_notes_status CHECK (status IN ('Draft', 'Issued', 'Applied', 'Void'));

ALTER TABLE fin.credit_notes
  ADD CONSTRAINT ck_credit_notes_amount_positive CHECK (amount > 0);

-- fk_credit_notes_invoice is added in 06_Fin/Invoices/003_Constraints.sql
-- instead — Invoices sorts alphabetically after CreditNotes.
