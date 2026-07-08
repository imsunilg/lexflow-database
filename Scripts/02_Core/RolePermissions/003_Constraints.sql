ALTER TABLE core.role_permissions
  ADD CONSTRAINT fk_role_permissions_permission FOREIGN KEY (permission_id) REFERENCES core.permissions (id);

-- fk_role_permissions_role is added in 02_Core/Roles/003_Constraints.sql instead
-- of here — Roles sorts alphabetically after RolePermissions (Build Playbook
-- §1.1 per-object execution order), so core.roles doesn't exist yet at this point.
