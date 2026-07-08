ALTER TABLE ops.recurrence_exceptions
  ADD CONSTRAINT ck_recurrence_exceptions_type CHECK (exception_type IN ('Modified', 'Cancelled'));

ALTER TABLE ops.recurrence_exceptions
  ADD CONSTRAINT fk_recurrence_exceptions_event FOREIGN KEY (event_id) REFERENCES ops.calendar_events (id);
