ALTER TABLE legal.case_parties
  ADD CONSTRAINT fk_case_parties_advocate_user FOREIGN KEY (advocate_user_id) REFERENCES core.users (id);

-- fk_case_parties_case is added in 04_Legal/CourtCases/003_Constraints.sql
-- instead of here — CourtCases sorts alphabetically after CaseParties.
