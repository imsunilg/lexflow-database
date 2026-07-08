-- Forward-reference FKs hoisted here: IpAllowlists and RolePermissions both
-- sort alphabetically before Roles (Build Playbook §1.1 per-object execution
-- order), so core.roles doesn't exist yet when their own 003_Constraints.sql
-- would otherwise run. See 02_Core/Users/003_Constraints.sql for the same
-- pattern applied to the (much larger) set of tables referencing core.users.
ALTER TABLE core.ip_allowlists
  ADD CONSTRAINT fk_ip_allowlists_role FOREIGN KEY (role_id) REFERENCES core.roles (id);

ALTER TABLE core.role_permissions
  ADD CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES core.roles (id);
