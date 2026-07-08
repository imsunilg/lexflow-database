ALTER TABLE ops.external_event_links
  ADD CONSTRAINT fk_external_event_links_event FOREIGN KEY (event_id) REFERENCES ops.calendar_events (id);

ALTER TABLE ops.external_event_links
  ADD CONSTRAINT fk_external_event_links_account FOREIGN KEY (external_account_id) REFERENCES ops.external_calendar_accounts (id);
