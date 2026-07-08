-- BR-4 Invoice immutability (see 06_Fin/InvoiceLines/004_Triggers.sql for
-- the identical rationale — tax lines are part of the immutable invoice
-- total computation).
CREATE OR REPLACE FUNCTION fin.trg_invoice_taxes_block_non_draft_mutation() RETURNS trigger AS $$
DECLARE
  v_invoice_id uuid;
  v_status text;
BEGIN
  v_invoice_id := COALESCE(NEW.invoice_id, OLD.invoice_id);
  SELECT status INTO v_status FROM fin.invoices WHERE id = v_invoice_id;
  IF v_status IS NOT NULL AND v_status <> 'Draft' THEN
    RAISE EXCEPTION 'BR-4 violated: invoice % is not Draft (status %) — invoice taxes are immutable once sent; correct via credit note instead', v_invoice_id, v_status;
  END IF;
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_invoice_taxes_block_non_draft_mutation
  BEFORE INSERT OR UPDATE OR DELETE ON fin.invoice_taxes
  FOR EACH ROW EXECUTE FUNCTION fin.trg_invoice_taxes_block_non_draft_mutation();
