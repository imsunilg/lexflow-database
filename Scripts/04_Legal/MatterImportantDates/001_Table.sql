-- PROMPT DB-4. PRD §18 (legal.matter_important_dates), Module 4, BR-2.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- matter_id FK: added in 04_Legal/Matters/003_Constraints.sql, not here —
-- Matters sorts alphabetically after MatterImportantDates (Build Playbook
-- §1.1 per-object execution order), so legal.matters doesn't exist yet here.
CREATE TABLE legal.matter_important_dates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  matter_id uuid NOT NULL,
  kind text NOT NULL,
  title text NOT NULL,
  due_at timestamptz NOT NULL,
  satisfied_at timestamptz,
  satisfied_note text,
  reminder_policy jsonb NOT NULL DEFAULT '{}'::jsonb,
  severity text,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
