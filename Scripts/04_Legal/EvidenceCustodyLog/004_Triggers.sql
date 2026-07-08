-- Append-only guard (PRD §18 comment on evidence_custody_log; Module 5
-- AC-CC5: "Evidence item shows complete custody chain; edits append, never
-- overwrite"). Blocks UPDATE and DELETE unconditionally — corrections are
-- new rows, never edits of history.
CREATE OR REPLACE FUNCTION legal.trg_evidence_custody_log_block_mutation() RETURNS trigger AS $$
BEGIN
  RAISE EXCEPTION 'legal.evidence_custody_log is append-only — % is not permitted (PRD §18 / AC-CC5)', TG_OP;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_evidence_custody_log_block_update
  BEFORE UPDATE ON legal.evidence_custody_log
  FOR EACH ROW
  EXECUTE FUNCTION legal.trg_evidence_custody_log_block_mutation();

CREATE TRIGGER trg_evidence_custody_log_block_delete
  BEFORE DELETE ON legal.evidence_custody_log
  FOR EACH ROW
  EXECUTE FUNCTION legal.trg_evidence_custody_log_block_mutation();
