-- PRD Module 16 Architecture: "Every AI action logged (ai_interactions: feature,
-- prompt-template id, model, tokens, latency, user, target refs, feedback) — prompts/outputs
-- retained per firm policy (default 90 days)." Feedback loop (§35): "thumbs + reason on every
-- output."
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- user_id FK -> core.users(id) is backward-safe and added below.
CREATE TABLE ai.ai_interactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  feature text NOT NULL,
  prompt_template_key text NOT NULL,
  prompt_template_version text NOT NULL,
  model text NOT NULL,
  tokens_input int NOT NULL DEFAULT 0,
  tokens_output int NOT NULL DEFAULT 0,
  latency_ms int NOT NULL DEFAULT 0,
  credits_charged numeric(10, 2) NOT NULL DEFAULT 0,
  user_id uuid,
  target_ref_kind text,
  target_ref_id uuid,
  input_text text,
  output_text text,
  rating int,
  rating_reason text,
  created_at timestamptz NOT NULL DEFAULT now(),
  retention_expires_at timestamptz
);
