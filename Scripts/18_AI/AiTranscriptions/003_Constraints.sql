ALTER TABLE ai.ai_transcriptions
  ADD CONSTRAINT fk_ai_transcriptions_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

ALTER TABLE ai.ai_transcriptions
  ADD CONSTRAINT fk_ai_transcriptions_requested_by FOREIGN KEY (requested_by) REFERENCES core.users (id);

ALTER TABLE ai.ai_transcriptions
  ADD CONSTRAINT ck_ai_transcriptions_status CHECK (status IN ('Queued', 'Processing', 'Done', 'Failed'));
