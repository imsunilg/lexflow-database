ALTER TABLE core.user_permission_grants
  ADD CONSTRAINT fk_upg_permission FOREIGN KEY (permission_id) REFERENCES core.permissions (id);

-- fk_upg_user is added in 02_Core/Users/003_Constraints.sql instead of here —
-- Users sorts alphabetically after UserPermissionGrants (Build Playbook §1.1
-- per-object execution order), so core.users doesn't exist yet at this point.
