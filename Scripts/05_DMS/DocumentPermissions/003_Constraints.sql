ALTER TABLE dms.document_permissions
  ADD CONSTRAINT ck_document_permissions_principal_type CHECK (principal_type IN ('user', 'team', 'role', 'portal_client', 'link'));

ALTER TABLE dms.document_permissions
  ADD CONSTRAINT ck_document_permissions_access CHECK (access IN ('view', 'edit'));

-- fk_document_permissions_document is added in
-- 05_DMS/Documents/003_Constraints.sql instead — Documents sorts
-- alphabetically after DocumentPermissions.
