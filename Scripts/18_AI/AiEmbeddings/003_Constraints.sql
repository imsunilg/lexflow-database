ALTER TABLE ai.ai_embeddings
  ADD CONSTRAINT ck_ai_embeddings_source_kind CHECK (source_kind IN ('Document', 'Matter', 'KbJudgment', 'KbArticle', 'KbActSection'));
