-- PROMPT DB-2. PRD §14, §18 (core.login_history), §20(12) (every login attempt logged).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- user_id is nullable: a failed attempt against an unknown/nonexistent email
-- still needs to be logged (anomaly detection, lockout policy).
-- user_id FK: added in 02_Core/Users/003_Constraints.sql — Users sorts
-- alphabetically after LoginHistory (Build Playbook §1.1 per-object execution
-- order), so core.users doesn't exist yet at this point.
CREATE TABLE core.login_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  user_id uuid,
  at timestamptz NOT NULL DEFAULT now(),
  ip inet,
  ua text,
  result text NOT NULL,
  failure_reason text,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
