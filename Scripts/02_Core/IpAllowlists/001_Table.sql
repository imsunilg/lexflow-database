-- PROMPT DB-2. PRD §14, §20(10) (IP restriction, Enterprise: allow-list per role/tenant).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- role_id is nullable: a NULL role_id means the CIDR applies tenant-wide,
-- not to one specific role.
-- role_id FK: added in 02_Core/Roles/003_Constraints.sql — Roles sorts
-- alphabetically after IpAllowlists (Build Playbook §1.1 per-object execution
-- order), so core.roles doesn't exist yet at this point.
CREATE TABLE core.ip_allowlists (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  role_id uuid,
  cidr_range cidr NOT NULL,
  description text,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
