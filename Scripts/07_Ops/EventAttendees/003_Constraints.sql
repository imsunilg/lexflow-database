ALTER TABLE ops.event_attendees
  ADD CONSTRAINT ck_event_attendees_status CHECK (status IN ('Pending', 'Accepted', 'Declined', 'Tentative'));

ALTER TABLE ops.event_attendees
  ADD CONSTRAINT ck_event_attendees_user_or_email CHECK (user_id IS NOT NULL OR email IS NOT NULL);

ALTER TABLE ops.event_attendees
  ADD CONSTRAINT fk_event_attendees_event FOREIGN KEY (event_id) REFERENCES ops.calendar_events (id);

ALTER TABLE ops.event_attendees
  ADD CONSTRAINT fk_event_attendees_user FOREIGN KEY (user_id) REFERENCES core.users (id);
