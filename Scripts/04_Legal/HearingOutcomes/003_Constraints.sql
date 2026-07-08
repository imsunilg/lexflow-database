-- Module 5 validation: "outcome requires summary ≥ 10 chars".
ALTER TABLE legal.hearing_outcomes
  ADD CONSTRAINT ck_hearing_outcomes_summary_length CHECK (length(summary) >= 10);

ALTER TABLE legal.hearing_outcomes
  ADD CONSTRAINT fk_hearing_outcomes_recorded_by FOREIGN KEY (recorded_by) REFERENCES core.users (id);

-- fk_hearing_outcomes_hearing is added in 04_Legal/Hearings/003_Constraints.sql
-- instead of here — Hearings sorts alphabetically after HearingOutcomes.
