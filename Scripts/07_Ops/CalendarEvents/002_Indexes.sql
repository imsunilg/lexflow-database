CREATE INDEX ix_calendar_events_tenant ON ops.calendar_events (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_calendar_events_tenant_starts ON ops.calendar_events (tenant_id, starts_at) WHERE is_deleted = false;

CREATE INDEX ix_calendar_events_matter ON ops.calendar_events (matter_id) WHERE is_deleted = false;

CREATE INDEX ix_calendar_events_series ON ops.calendar_events (series_id) WHERE is_deleted = false;

CREATE INDEX ix_calendar_events_organizer ON ops.calendar_events (organizer_id) WHERE is_deleted = false;
