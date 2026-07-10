CREATE INDEX ix_ai_interactions_tenant_created ON ai.ai_interactions (tenant_id, created_at DESC);

CREATE INDEX ix_ai_interactions_tenant_user ON ai.ai_interactions (tenant_id, user_id);

CREATE INDEX ix_ai_interactions_target ON ai.ai_interactions (tenant_id, target_ref_kind, target_ref_id);

-- Backs the monthly credit-quota rollup (sum credits_charged WHERE tenant_id = ? AND created_at
-- in the current calendar month).
CREATE INDEX ix_ai_interactions_tenant_feature_created ON ai.ai_interactions (tenant_id, feature, created_at);
