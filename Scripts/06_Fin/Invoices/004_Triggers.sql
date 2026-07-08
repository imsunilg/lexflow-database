-- BR-4 Invoice immutability: "Sent invoices are immutable; corrections via
-- credit note + reissue. Numbers sequential per series per FY; voids retain
-- number." Once an invoice leaves Draft, its content fields (totals,
-- currency, dates, party links, number/series, notes, pdf) can no longer be
-- changed directly — only status transitions (Submitted->Approved->Sent->
-- Paid/Overdue/Void etc.), sent_at/voided_at/void_reason, and amount_paid
-- (which must keep advancing as payments are allocated) are allowed to move.
CREATE OR REPLACE FUNCTION fin.trg_invoices_block_non_draft_mutation() RETURNS trigger AS $$
BEGIN
  IF OLD.status <> 'Draft' AND (
       NEW.number IS DISTINCT FROM OLD.number
    OR NEW.series_id IS DISTINCT FROM OLD.series_id
    OR NEW.matter_id IS DISTINCT FROM OLD.matter_id
    OR NEW.client_id IS DISTINCT FROM OLD.client_id
    OR NEW.currency IS DISTINCT FROM OLD.currency
    OR NEW.issue_date IS DISTINCT FROM OLD.issue_date
    OR NEW.due_date IS DISTINCT FROM OLD.due_date
    OR NEW.sub_total IS DISTINCT FROM OLD.sub_total
    OR NEW.discount_total IS DISTINCT FROM OLD.discount_total
    OR NEW.tax_total IS DISTINCT FROM OLD.tax_total
    OR NEW.grand_total IS DISTINCT FROM OLD.grand_total
    OR NEW.notes IS DISTINCT FROM OLD.notes
    OR NEW.pdf_blob_path IS DISTINCT FROM OLD.pdf_blob_path
  ) THEN
    RAISE EXCEPTION 'BR-4 violated: invoice % is not Draft (status %) — lines/totals are immutable once sent; correct via credit note instead', OLD.id, OLD.status;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_invoices_block_non_draft_mutation
  BEFORE UPDATE ON fin.invoices
  FOR EACH ROW EXECUTE FUNCTION fin.trg_invoices_block_non_draft_mutation();
