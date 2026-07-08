ALTER TABLE ops.reminder_dispatch_log
  ADD CONSTRAINT ck_reminder_dispatch_log_channel CHECK (channel IN ('Email', 'SMS', 'WhatsApp', 'Push', 'InApp'));

ALTER TABLE ops.reminder_dispatch_log
  ADD CONSTRAINT ck_reminder_dispatch_log_status CHECK (status IN ('Sent', 'Failed'));

ALTER TABLE ops.reminder_dispatch_log
  ADD CONSTRAINT fk_reminder_dispatch_log_reminder FOREIGN KEY (reminder_id) REFERENCES ops.event_reminders (id);
