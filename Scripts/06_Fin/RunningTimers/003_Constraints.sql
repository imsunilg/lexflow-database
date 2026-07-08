ALTER TABLE fin.running_timers
  ADD CONSTRAINT ck_running_timers_paused_ms_nonnegative CHECK (paused_ms >= 0);

ALTER TABLE fin.running_timers
  ADD CONSTRAINT fk_running_timers_user FOREIGN KEY (user_id) REFERENCES core.users (id);

ALTER TABLE fin.running_timers
  ADD CONSTRAINT fk_running_timers_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);
