ALTER TABLE fin.time_entries
  ADD CONSTRAINT ck_time_entries_status CHECK (status IN ('Draft', 'Submitted', 'Approved', 'Rejected', 'Billed', 'WrittenOff'));

ALTER TABLE fin.time_entries
  ADD CONSTRAINT ck_time_entries_source CHECK (source IN ('timer', 'manual', 'suggested'));

ALTER TABLE fin.time_entries
  ADD CONSTRAINT ck_time_entries_duration_range CHECK (duration_min BETWEEN 1 AND 1440);

ALTER TABLE fin.time_entries
  ADD CONSTRAINT ck_time_entries_rounded_nonnegative CHECK (rounded_min >= 0);

ALTER TABLE fin.time_entries
  ADD CONSTRAINT fk_time_entries_user FOREIGN KEY (user_id) REFERENCES core.users (id);

ALTER TABLE fin.time_entries
  ADD CONSTRAINT fk_time_entries_approved_by FOREIGN KEY (approved_by) REFERENCES core.users (id);

ALTER TABLE fin.time_entries
  ADD CONSTRAINT fk_time_entries_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

ALTER TABLE fin.time_entries
  ADD CONSTRAINT fk_time_entries_activity_code FOREIGN KEY (activity_code_id) REFERENCES fin.activity_codes (id);

ALTER TABLE fin.time_entries
  ADD CONSTRAINT fk_time_entries_invoice_line FOREIGN KEY (invoice_line_id) REFERENCES fin.invoice_lines (id);
