ALTER TABLE ops.event_reminders
  ADD CONSTRAINT ck_event_reminders_ref_kind CHECK (event_ref_kind IN ('event', 'hearing', 'deadline', 'task'));

ALTER TABLE ops.event_reminders
  ADD CONSTRAINT ck_event_reminders_channel CHECK (channel IN ('Email', 'SMS', 'WhatsApp', 'Push', 'InApp'));

ALTER TABLE ops.event_reminders
  ADD CONSTRAINT ck_event_reminders_status CHECK (status IN ('Pending', 'Sent', 'Failed'));

-- Module 6 validation rule: "reminder offsets 0–90 days".
ALTER TABLE ops.event_reminders
  ADD CONSTRAINT ck_event_reminders_offset_range CHECK (offset_minutes BETWEEN 0 AND 129600);
