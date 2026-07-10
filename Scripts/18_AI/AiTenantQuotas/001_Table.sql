-- PRD Module 16 Architecture: "Cost: per-tenant monthly AI-credit quota by tier; metered per
-- feature; graceful 'quota reached' state." One row per tenant (tenant_id is the PK, same
-- single-row-per-owner shape as fin.running_timers' user_id PK) — credits consumed are derived
-- at query time from ai.ai_interactions.credits_charged for the current calendar month, never
-- double-booked here; this table only holds the configured ceiling.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
CREATE TABLE ai.ai_tenant_quotas (
  tenant_id uuid PRIMARY KEY,
  monthly_credit_limit numeric(12, 2) NOT NULL DEFAULT 1000,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz
);
