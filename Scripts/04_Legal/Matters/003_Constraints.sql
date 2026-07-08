-- Matters' own constraints.
ALTER TABLE legal.matters
  ADD CONSTRAINT ck_matters_status CHECK (status IN ('Open', 'OnHold', 'Closed', 'Reopened'));

ALTER TABLE legal.matters
  ADD CONSTRAINT ck_matters_type CHECK (matter_type IN ('Litigation', 'Advisory', 'Transactional', 'Arbitration', 'Compliance'));

ALTER TABLE legal.matters
  ADD CONSTRAINT ck_matters_priority CHECK (priority IN ('Low', 'Medium', 'High', 'Critical'));

ALTER TABLE legal.matters
  ADD CONSTRAINT ck_matters_outcome CHECK (outcome IS NULL OR outcome IN ('Won', 'Lost', 'Settled', 'Withdrawn'));

-- Module 4 validation: "open date ≤ today".
ALTER TABLE legal.matters
  ADD CONSTRAINT ck_matters_opened_on_not_future CHECK (opened_on <= current_date);

ALTER TABLE legal.matters
  ADD CONSTRAINT ck_matters_budget_nonnegative CHECK (budget IS NULL OR budget >= 0);

ALTER TABLE legal.matters
  ADD CONSTRAINT fk_matters_client FOREIGN KEY (client_id) REFERENCES crm.clients (id);

ALTER TABLE legal.matters
  ADD CONSTRAINT fk_matters_branch FOREIGN KEY (branch_id) REFERENCES core.branches (id);

ALTER TABLE legal.matters
  ADD CONSTRAINT fk_matters_responsible_lawyer FOREIGN KEY (responsible_lawyer_id) REFERENCES core.users (id);

-- Forward-reference FKs hoisted here from other 04_Legal objects — CourtCases,
-- MatterExpenses, MatterImportantDates, MatterParties, MatterRelated and
-- MatterTeamMembers all sort alphabetically before Matters (Build Playbook
-- §1.1 per-object execution order), so their FKs to legal.matters must be
-- added here instead of in their own 003_Constraints.sql. Same pattern as
-- 02_Core/Users/003_Constraints.sql.
ALTER TABLE legal.court_cases
  ADD CONSTRAINT fk_court_cases_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

ALTER TABLE legal.matter_expenses
  ADD CONSTRAINT fk_matter_expenses_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

ALTER TABLE legal.matter_important_dates
  ADD CONSTRAINT fk_matter_important_dates_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

ALTER TABLE legal.matter_parties
  ADD CONSTRAINT fk_matter_parties_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

ALTER TABLE legal.matter_related
  ADD CONSTRAINT fk_matter_related_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

ALTER TABLE legal.matter_related
  ADD CONSTRAINT fk_matter_related_related_matter FOREIGN KEY (related_matter_id) REFERENCES legal.matters (id);

ALTER TABLE legal.matter_team_members
  ADD CONSTRAINT fk_matter_team_members_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

-- practice_area_id is not FK'd here — that FK is hoisted forward into
-- PracticeAreas/003_Constraints.sql (PracticeAreas sorts after Matters).
