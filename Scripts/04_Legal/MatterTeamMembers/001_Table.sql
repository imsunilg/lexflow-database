-- PROMPT DB-4. PRD §18 (legal.matter_team_members(matter_id, user_id,
-- role_in_matter, rate_override)).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- matter_id FK: added in 04_Legal/Matters/003_Constraints.sql, not here —
-- Matters sorts alphabetically after MatterTeamMembers (Build Playbook §1.1
-- per-object execution order), so legal.matters doesn't exist yet here.
-- user_id FK -> core.users(id) is backward-safe and added below.
CREATE TABLE legal.matter_team_members (
  tenant_id uuid NOT NULL,
  matter_id uuid NOT NULL,
  user_id uuid NOT NULL,
  role_in_matter text,
  rate_override numeric(18, 4),
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid,
  PRIMARY KEY (matter_id, user_id)
);
