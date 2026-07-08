ALTER TABLE comm.chat_channels
  ADD CONSTRAINT ck_chat_channels_kind CHECK (kind IN ('Firm', 'Team', 'Matter', 'DM'));

ALTER TABLE comm.chat_channels
  ADD CONSTRAINT ck_chat_channels_retention_positive CHECK (retention_days IS NULL OR retention_days > 0);

ALTER TABLE comm.chat_channels
  ADD CONSTRAINT fk_chat_channels_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

ALTER TABLE comm.chat_channels
  ADD CONSTRAINT fk_chat_channels_team FOREIGN KEY (team_id) REFERENCES core.teams (id);
