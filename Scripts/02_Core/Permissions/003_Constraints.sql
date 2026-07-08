ALTER TABLE core.permissions
  ADD CONSTRAINT ck_permissions_scope CHECK (scope IN ('own', 'team', 'branch', 'all', 'special'));
