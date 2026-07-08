-- Hearings' own constraints.
ALTER TABLE legal.hearings
  ADD CONSTRAINT ck_hearings_status CHECK (status IN ('Scheduled', 'Held', 'Adjourned', 'Cancelled'));

ALTER TABLE legal.hearings
  ADD CONSTRAINT fk_hearings_case FOREIGN KEY (case_id) REFERENCES legal.court_cases (id);

ALTER TABLE legal.hearings
  ADD CONSTRAINT fk_hearings_assigned_lawyer FOREIGN KEY (assigned_lawyer_id) REFERENCES core.users (id);

-- Forward-reference FKs hoisted here from other 04_Legal objects — ArgumentNotes,
-- CourtOrders and HearingOutcomes all sort alphabetically before Hearings
-- (Build Playbook §1.1 per-object execution order), so their FKs to
-- legal.hearings must be added here instead of in their own 003_Constraints.sql.
ALTER TABLE legal.argument_notes
  ADD CONSTRAINT fk_argument_notes_hearing FOREIGN KEY (hearing_id) REFERENCES legal.hearings (id);

ALTER TABLE legal.court_orders
  ADD CONSTRAINT fk_court_orders_hearing FOREIGN KEY (hearing_id) REFERENCES legal.hearings (id);

ALTER TABLE legal.hearing_outcomes
  ADD CONSTRAINT fk_hearing_outcomes_hearing FOREIGN KEY (hearing_id) REFERENCES legal.hearings (id);
