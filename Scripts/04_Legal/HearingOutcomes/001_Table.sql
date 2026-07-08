-- PROMPT DB-4. PRD §18 (legal.hearing_outcomes), Module 5.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- hearing_id FK: added in 04_Legal/Hearings/003_Constraints.sql, not here —
-- Hearings sorts alphabetically after HearingOutcomes (Build Playbook §1.1
-- per-object execution order), so legal.hearings doesn't exist yet at this
-- point. recorded_by FK -> core.users(id) is backward-safe and added below.
CREATE TABLE legal.hearing_outcomes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  hearing_id uuid NOT NULL,
  summary text NOT NULL,
  adjourn_reason text,
  recorded_by uuid,
  recorded_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
