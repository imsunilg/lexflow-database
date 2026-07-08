-- PROMPT DB-2. PRD §14, §18, §21. Composite-PK join table (user_id, permission_id),
-- mirroring the RolePermissions/UserRoles pattern for extra ad-hoc grants beyond
-- a user's primary role.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- granted_by: the acting user; intentionally NOT a foreign key, same reasoning
-- as created_by/updated_by/deleted_by (see 02_Core/Users/003_Constraints.sql).
CREATE TABLE core.user_permission_grants (
  tenant_id uuid NOT NULL,
  user_id uuid NOT NULL,
  permission_id uuid NOT NULL,
  granted_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid,
  PRIMARY KEY (user_id, permission_id)
);
