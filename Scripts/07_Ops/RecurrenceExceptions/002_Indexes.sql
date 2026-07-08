CREATE INDEX ix_recurrence_exceptions_tenant ON ops.recurrence_exceptions (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_recurrence_exceptions_event_date ON ops.recurrence_exceptions (event_id, occurrence_date) WHERE is_deleted = false;
