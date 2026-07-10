ALTER TABLE rpt.report_runs
  ADD CONSTRAINT fk_report_runs_definition FOREIGN KEY (report_definition_id) REFERENCES rpt.report_definitions (id);

ALTER TABLE rpt.report_runs
  ADD CONSTRAINT ck_report_runs_status CHECK (status IN ('Queued', 'Running', 'Completed', 'Failed'));

ALTER TABLE rpt.report_runs
  ADD CONSTRAINT ck_report_runs_key_or_definition CHECK (report_key IS NOT NULL OR report_definition_id IS NOT NULL);
