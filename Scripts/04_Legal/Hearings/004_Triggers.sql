-- BR-6 / AC-CC3 — see 04_Legal/HearingOutcomes/004_Triggers.sql for the full
-- explanation of the shared predicate function and why these are DEFERRABLE
-- constraint triggers. legal.fn_hearing_chain_invariant_holds() is defined
-- there (HearingOutcomes sorts before Hearings, so it already exists here).
CREATE OR REPLACE FUNCTION legal.trg_hearings_check_chain_invariant() RETURNS trigger AS $$
BEGIN
  IF NOT legal.fn_hearing_chain_invariant_holds(NEW.case_id) THEN
    RAISE EXCEPTION 'BR-6 violated: court_case % has no future scheduled hearing, and is not disposed/transferred/sine-die (PRD AC-CC3)', NEW.case_id;
  END IF;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER trg_hearings_check_chain_invariant
  AFTER INSERT OR UPDATE ON legal.hearings
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  EXECUTE FUNCTION legal.trg_hearings_check_chain_invariant();
