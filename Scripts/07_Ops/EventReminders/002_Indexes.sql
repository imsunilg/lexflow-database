CREATE INDEX ix_event_reminders_tenant ON ops.event_reminders (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_event_reminders_ref ON ops.event_reminders (event_ref_kind, event_ref_id) WHERE is_deleted = false;

CREATE INDEX ix_event_reminders_pending ON ops.event_reminders (status) WHERE status = 'Pending' AND is_deleted = false;
