-- PROMPT DB-2. PRD §14, §18 (core.user_sessions), §20(3) (refresh-token rotation,
-- family-based reuse detection).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- user_id FK: added in 02_Core/Users/003_Constraints.sql — Users sorts
-- alphabetically after Sessions (Build Playbook §1.1 per-object execution
-- order), so core.users doesn't exist yet at this point.
CREATE TABLE core.user_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  user_id uuid NOT NULL,
  refresh_hash text NOT NULL,
  family_id uuid NOT NULL,
  ua text,
  ip inet,
  expires_at timestamptz NOT NULL,
  revoked_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
