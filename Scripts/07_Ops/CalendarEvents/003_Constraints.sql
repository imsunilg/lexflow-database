ALTER TABLE ops.calendar_events
  ADD CONSTRAINT ck_calendar_events_kind CHECK (kind IN ('Meeting', 'Personal'));

-- Module 6 validation rule: "end > start".
ALTER TABLE ops.calendar_events
  ADD CONSTRAINT ck_calendar_events_end_after_start CHECK (ends_at > starts_at);

-- Module 6 validation rule: "duration ≤ 14 days".
ALTER TABLE ops.calendar_events
  ADD CONSTRAINT ck_calendar_events_duration_max CHECK (ends_at <= starts_at + interval '14 days');

ALTER TABLE ops.calendar_events
  ADD CONSTRAINT fk_calendar_events_series FOREIGN KEY (series_id) REFERENCES ops.calendar_events (id);

ALTER TABLE ops.calendar_events
  ADD CONSTRAINT ck_calendar_events_no_self_series CHECK (series_id IS NULL OR series_id <> id);

ALTER TABLE ops.calendar_events
  ADD CONSTRAINT fk_calendar_events_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

ALTER TABLE ops.calendar_events
  ADD CONSTRAINT fk_calendar_events_organizer FOREIGN KEY (organizer_id) REFERENCES core.users (id);
