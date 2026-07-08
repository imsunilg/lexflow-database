ALTER TABLE legal.judges
  ADD CONSTRAINT fk_judges_court FOREIGN KEY (court_id) REFERENCES legal.courts (id);

-- Forward-reference FK hoisted here: CourtCases sorts alphabetically before
-- Judges (Build Playbook §1.1 per-object execution order), so legal.judges
-- doesn't exist yet when CourtCases' own 003_Constraints.sql would otherwise run.
ALTER TABLE legal.court_cases
  ADD CONSTRAINT fk_court_cases_judge FOREIGN KEY (judge_id) REFERENCES legal.judges (id);
