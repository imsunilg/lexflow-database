-- BR-6 / AC-CC3 (PRD §9, Module 5): "A non-disposed case must always have
-- exactly one of: future hearing, sine-die flag, or transfer/appeal closure
-- state." — "No court case can be in state 'no future hearing & not disposed
-- & not sine-die' (DB constraint + nightly integrity job)."
--
-- legal.fn_hearing_chain_invariant_holds() is the single shared predicate,
-- defined here (in HearingOutcomes) rather than in Hearings, specifically
-- because HearingOutcomes sorts alphabetically BEFORE Hearings (Build
-- Playbook §1.1 per-object execution order) — defining the shared function
-- here means Hearings/004_Triggers.sql can reference it without any forward
-- dependency. The function itself queries legal.hearings, which is safe even
-- though that table doesn't exist yet at migration time: PL/pgSQL function
-- bodies are not resolved against real objects until first execution, and by
-- the time any hearing_outcomes row is actually written, migration has long
-- since finished and legal.hearings exists.
--
-- Both this trigger and the one in Hearings/004_Triggers.sql are DEFERRABLE
-- constraint triggers (checked at COMMIT, not immediately after each row).
-- This is required, not cosmetic: AC-CC1 has "recording an outcome with next
-- date creates next hearing + reminders ... in one transaction" — the
-- hearing_outcomes row and the replacement hearing row are written in the
-- same transaction, in either order. An immediate (non-deferred) trigger
-- would see an inconsistent intermediate state and reject a perfectly valid
-- transaction; deferring the check to COMMIT lets the invariant be evaluated
-- only once the whole transaction's writes are visible.
CREATE OR REPLACE FUNCTION legal.fn_hearing_chain_invariant_holds(p_case_id uuid) RETURNS boolean AS $$
DECLARE
  v_status text;
  v_has_future_scheduled boolean;
BEGIN
  SELECT status INTO v_status FROM legal.court_cases WHERE id = p_case_id;

  IF v_status IS NULL THEN
    RETURN true; -- case row not found — nothing for this trigger to enforce
  END IF;

  IF v_status IN ('Disposed', 'Transferred', 'SineDie') THEN
    RETURN true;
  END IF;

  SELECT EXISTS (
    SELECT 1
    FROM legal.hearings h
    WHERE h.case_id = p_case_id
      AND h.status = 'Scheduled'
      AND h.date >= current_date
      AND h.is_deleted = false
  ) INTO v_has_future_scheduled;

  RETURN v_has_future_scheduled;
END;
$$ LANGUAGE plpgsql STABLE;

CREATE OR REPLACE FUNCTION legal.trg_hearing_outcomes_check_chain_invariant() RETURNS trigger AS $$
DECLARE
  v_case_id uuid;
BEGIN
  SELECT case_id INTO v_case_id FROM legal.hearings WHERE id = NEW.hearing_id;

  IF v_case_id IS NOT NULL AND NOT legal.fn_hearing_chain_invariant_holds(v_case_id) THEN
    RAISE EXCEPTION 'BR-6 violated: court_case % has no future scheduled hearing, and is not disposed/transferred/sine-die (PRD AC-CC3)', v_case_id;
  END IF;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER trg_hearing_outcomes_check_chain_invariant
  AFTER INSERT OR UPDATE ON legal.hearing_outcomes
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  EXECUTE FUNCTION legal.trg_hearing_outcomes_check_chain_invariant();
