-- Forward-reference FK hoisted here: DunningEvents sorts alphabetically
-- before DunningSchedules (Build Playbook §1.1 per-object execution order),
-- so fin.dunning_schedules doesn't exist yet when DunningEvents' own
-- 003_Constraints.sql would otherwise run.
ALTER TABLE fin.dunning_events
  ADD CONSTRAINT fk_dunning_events_schedule FOREIGN KEY (schedule_id) REFERENCES fin.dunning_schedules (id);
