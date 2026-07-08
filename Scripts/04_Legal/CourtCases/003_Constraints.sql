-- CourtCases' own constraints.
ALTER TABLE legal.court_cases
  ADD CONSTRAINT ck_court_cases_status CHECK (status IN ('Active', 'Disposed', 'Transferred', 'SineDie'));

ALTER TABLE legal.court_cases
  ADD CONSTRAINT fk_court_cases_appeal_of FOREIGN KEY (appeal_of_case_id) REFERENCES legal.court_cases (id);

-- Forward-reference FKs hoisted here from other 04_Legal objects — ArgumentNotes
-- and CaseParties both sort alphabetically before CourtCases (Build Playbook
-- §1.1 per-object execution order), so their FKs to legal.court_cases must be
-- added here instead of in their own 003_Constraints.sql. Same pattern as
-- 02_Core/Users/003_Constraints.sql.
ALTER TABLE legal.argument_notes
  ADD CONSTRAINT fk_argument_notes_case FOREIGN KEY (case_id) REFERENCES legal.court_cases (id);

ALTER TABLE legal.case_parties
  ADD CONSTRAINT fk_case_parties_case FOREIGN KEY (case_id) REFERENCES legal.court_cases (id);

-- court_id, judge_id, matter_id are not FK'd here — those FKs are hoisted
-- forward into Courts/003_Constraints.sql, Judges/003_Constraints.sql and
-- Matters/003_Constraints.sql respectively (all three sort after CourtCases).
