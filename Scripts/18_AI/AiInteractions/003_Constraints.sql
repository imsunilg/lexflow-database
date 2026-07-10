ALTER TABLE ai.ai_interactions
  ADD CONSTRAINT fk_ai_interactions_user FOREIGN KEY (user_id) REFERENCES core.users (id);

ALTER TABLE ai.ai_interactions
  ADD CONSTRAINT ck_ai_interactions_rating CHECK (rating IS NULL OR rating IN (-1, 1));
