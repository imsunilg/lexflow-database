ALTER TABLE ops.notifications
  ADD CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES core.users (id);
