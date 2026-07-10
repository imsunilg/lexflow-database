-- PRD §14 (multi-tenant isolation convention) / §20(5). RLS for the ai schema. Lives inside
-- this folder (rather than 15_RLS_Policies, where every other schema's policies live) because
-- 15_RLS_Policies executes before 18_AI in the top-level folder order (Build Playbook §1.1) —
-- the ai.* tables wouldn't exist yet. The "zzz_" prefix sorts this file after every table
-- folder in this directory (000_Schema.sql, then AiEmbeddings/AiInteractions/AiTenantQuotas/
-- AiTranscriptions alphabetically), so every table below already exists when this runs. Same
-- pattern established for rpt.* in 17_Reporting_StarSchema/zzz_RLS_Policies.sql.

ALTER TABLE ai.ai_tenant_quotas ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai.ai_tenant_quotas FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ai.ai_tenant_quotas
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ai.ai_interactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai.ai_interactions FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ai.ai_interactions
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ai.ai_embeddings ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai.ai_embeddings FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ai.ai_embeddings
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE ai.ai_transcriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai.ai_transcriptions FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON ai.ai_transcriptions
  USING (tenant_id = current_setting('app.tenant_id')::uuid);
