ALTER TABLE core.user_roles
  ADD CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES core.roles (id);

-- fk_user_roles_user is added in 02_Core/Users/003_Constraints.sql instead of
-- here — Users sorts alphabetically after UserRoles (Build Playbook §1.1
-- per-object execution order), so core.users doesn't exist yet at this point.
