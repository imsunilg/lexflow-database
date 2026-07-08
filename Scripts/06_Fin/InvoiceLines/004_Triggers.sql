-- BR-4 Invoice immutability: "Sent invoices are immutable; corrections via
-- credit note + reissue." Lines live in this child table, so the guardrail
-- on line mutation has to live here, not on fin.invoices itself.
-- fin.invoices does not exist yet at this point in the migration (Invoices
-- sorts alphabetically after InvoiceLines), but a PL/pgSQL function body is
-- only checked against real objects at first execution, so this is safe to
-- define here.
CREATE OR REPLACE FUNCTION fin.trg_invoice_lines_block_non_draft_mutation() RETURNS trigger AS $$
DECLARE
  v_invoice_id uuid;
  v_status text;
BEGIN
  v_invoice_id := COALESCE(NEW.invoice_id, OLD.invoice_id);
  SELECT status INTO v_status FROM fin.invoices WHERE id = v_invoice_id;
  IF v_status IS NOT NULL AND v_status <> 'Draft' THEN
    RAISE EXCEPTION 'BR-4 violated: invoice % is not Draft (status %) — invoice lines are immutable once sent; correct via credit note instead', v_invoice_id, v_status;
  END IF;
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_invoice_lines_block_non_draft_mutation
  BEFORE INSERT OR UPDATE OR DELETE ON fin.invoice_lines
  FOR EACH ROW EXECUTE FUNCTION fin.trg_invoice_lines_block_non_draft_mutation();
