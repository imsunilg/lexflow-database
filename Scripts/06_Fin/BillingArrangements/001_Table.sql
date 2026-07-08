-- PROMPT DB-6. PRD §18 / Module 8 (billing_arrangements): "Fee setup per
-- matter: Hourly (rate card + overrides), Fixed (total + optional
-- milestones), Retainer (amount, period, auto-invoice day, replenishment
-- threshold), Contingency (%), Pro Bono".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- matter_id FK -> legal.matters(id) is backward-safe (04_Legal already
-- built) and added below.
-- rate_card_id FK -> fin.rate_cards(id) is forward (RateCards sorts
-- alphabetically after BillingArrangements) — added in
-- 06_Fin/RateCards/003_Constraints.sql instead.
CREATE TABLE fin.billing_arrangements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  matter_id uuid NOT NULL,
  arrangement_type text NOT NULL,
  rate_card_id uuid,
  fixed_amount numeric(18, 2),
  milestones jsonb NOT NULL DEFAULT '[]'::jsonb,
  retainer_amount numeric(18, 2),
  retainer_period text,
  auto_invoice_day int,
  replenishment_threshold numeric(18, 2),
  contingency_pct numeric(5, 2),
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
