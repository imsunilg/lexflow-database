ALTER TABLE rpt.report_definitions
  ADD CONSTRAINT fk_report_definitions_owner FOREIGN KEY (owner_id) REFERENCES core.users (id);

ALTER TABLE rpt.report_definitions
  ADD CONSTRAINT ck_report_definitions_visibility CHECK (visibility IN ('private', 'team', 'firm'));
