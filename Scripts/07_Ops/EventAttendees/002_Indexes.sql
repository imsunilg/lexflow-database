CREATE INDEX ix_event_attendees_tenant ON ops.event_attendees (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_event_attendees_event ON ops.event_attendees (event_id) WHERE is_deleted = false;

CREATE INDEX ix_event_attendees_user ON ops.event_attendees (user_id) WHERE is_deleted = false;
