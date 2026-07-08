-- PROMPT DB-2. PRD §14, §18, Module 14. Composite-PK join table (team_id, user_id).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- team_id FK: added in 02_Core/Teams/003_Constraints.sql.
-- user_id FK: added in 02_Core/Users/003_Constraints.sql.
-- Both Teams and Users sort alphabetically after TeamMembers (Build Playbook
-- §1.1 per-object execution order), so neither table exists yet at this point.
CREATE TABLE core.team_members (
  tenant_id uuid NOT NULL,
  team_id uuid NOT NULL,
  user_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid,
  PRIMARY KEY (team_id, user_id)
);
