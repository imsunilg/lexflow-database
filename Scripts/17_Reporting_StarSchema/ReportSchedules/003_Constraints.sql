ALTER TABLE rpt.report_schedules
  ADD CONSTRAINT fk_report_schedules_definition FOREIGN KEY (report_definition_id) REFERENCES rpt.report_definitions (id);

ALTER TABLE rpt.report_schedules
  ADD CONSTRAINT ck_report_schedules_frequency CHECK (frequency IN ('daily', 'weekly', 'monthly'));

ALTER TABLE rpt.report_schedules
  ADD CONSTRAINT ck_report_schedules_format CHECK (format IN ('pdf', 'xlsx'));

ALTER TABLE rpt.report_schedules
  ADD CONSTRAINT ck_report_schedules_key_or_definition CHECK (report_key IS NOT NULL OR report_definition_id IS NOT NULL);

-- Forward-reference FK hoisted here: ReportRuns sorts alphabetically before
-- ReportSchedules (Build Playbook §1.1 per-object execution order), so
-- rpt.report_schedules doesn't exist yet when ReportRuns' own
-- 003_Constraints.sql would otherwise run.
ALTER TABLE rpt.report_runs
  ADD CONSTRAINT fk_report_runs_schedule FOREIGN KEY (schedule_id) REFERENCES rpt.report_schedules (id);
