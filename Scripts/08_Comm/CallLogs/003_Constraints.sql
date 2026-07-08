ALTER TABLE comm.call_logs
  ADD CONSTRAINT ck_call_logs_direction CHECK (direction IN ('Inbound', 'Outbound'));

ALTER TABLE comm.call_logs
  ADD CONSTRAINT ck_call_logs_duration_nonnegative CHECK (duration_sec >= 0);

-- Module 11 Security Rules: "recording requires consent setting on".
ALTER TABLE comm.call_logs
  ADD CONSTRAINT ck_call_logs_recording_requires_consent CHECK (recording_blob_path IS NULL OR consent_given = true);

ALTER TABLE comm.call_logs
  ADD CONSTRAINT fk_call_logs_client FOREIGN KEY (client_id) REFERENCES crm.clients (id);

ALTER TABLE comm.call_logs
  ADD CONSTRAINT fk_call_logs_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

ALTER TABLE comm.call_logs
  ADD CONSTRAINT fk_call_logs_user FOREIGN KEY (user_id) REFERENCES core.users (id);

ALTER TABLE comm.call_logs
  ADD CONSTRAINT fk_call_logs_follow_up_task FOREIGN KEY (follow_up_task_id) REFERENCES ops.tasks (id);
