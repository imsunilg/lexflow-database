-- PROMPT DB-6. PRD Module 8 / BR-7 (rate_card_entries): "rate card: default
-- firm rates by role, matter-level overrides per timekeeper"; BR-7 rate
-- resolution order: entry override → matter-member override → matter rate
-- card → firm default.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- user_id FK -> core.users(id) is backward-safe (02_Core already built) and
-- added below.
-- rate_card_id FK -> fin.rate_cards(id) is forward (RateCards sorts
-- alphabetically after RateCardEntries) — added in
-- 06_Fin/RateCards/003_Constraints.sql instead.
CREATE TABLE fin.rate_card_entries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  rate_card_id uuid NOT NULL,
  role text,
  user_id uuid,
  rate numeric(18, 4) NOT NULL,
  currency text NOT NULL DEFAULT 'INR',
  effective_from date NOT NULL DEFAULT current_date,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
