-- Courts' own constraints.
ALTER TABLE legal.courts
  ADD CONSTRAINT ck_courts_level CHECK (level IN ('Supreme', 'High', 'District', 'Tribunal', 'Consumer', 'Other'));

-- Forward-reference FKs hoisted here from other 04_Legal objects — CourtCases
-- and CourtHolidays both sort alphabetically before Courts (Build Playbook
-- §1.1 per-object execution order), so their FKs to legal.courts must be
-- added here instead of in their own 003_Constraints.sql.
ALTER TABLE legal.court_cases
  ADD CONSTRAINT fk_court_cases_court FOREIGN KEY (court_id) REFERENCES legal.courts (id);

ALTER TABLE legal.court_holidays
  ADD CONSTRAINT fk_court_holidays_court FOREIGN KEY (court_id) REFERENCES legal.courts (id);
