CREATE INDEX ix_ai_transcriptions_tenant ON ai.ai_transcriptions (tenant_id, created_at DESC);

CREATE INDEX ix_ai_transcriptions_matter ON ai.ai_transcriptions (tenant_id, matter_id);

CREATE INDEX ix_ai_transcriptions_status ON ai.ai_transcriptions (status) WHERE status IN ('Queued', 'Processing');
