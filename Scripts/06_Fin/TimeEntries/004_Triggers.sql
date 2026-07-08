-- BR-5 Time entry lock: "Entries become immutable at status Billed; edits
-- before that are audited with prior values." Once a time entry reaches
-- Billed, no further UPDATE or DELETE is permitted via any API path —
-- correction requires the credit-note + rebill flow (AC-T3).
CREATE OR REPLACE FUNCTION fin.trg_time_entries_block_billed_mutation() RETURNS trigger AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    IF OLD.status = 'Billed' THEN
      RAISE EXCEPTION 'BR-5 violated: time entry % is Billed — DELETE is not permitted; correct via credit note + rebill', OLD.id;
    END IF;
    RETURN OLD;
  END IF;

  IF OLD.status = 'Billed' THEN
    RAISE EXCEPTION 'BR-5 violated: time entry % is Billed — UPDATE is not permitted; correct via credit note + rebill', OLD.id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_time_entries_block_billed_update
  BEFORE UPDATE ON fin.time_entries
  FOR EACH ROW EXECUTE FUNCTION fin.trg_time_entries_block_billed_mutation();

CREATE TRIGGER trg_time_entries_block_billed_delete
  BEFORE DELETE ON fin.time_entries
  FOR EACH ROW EXECUTE FUNCTION fin.trg_time_entries_block_billed_mutation();
