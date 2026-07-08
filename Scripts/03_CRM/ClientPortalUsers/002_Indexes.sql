CREATE INDEX ix_client_portal_users_tenant ON crm.client_portal_users (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_client_portal_users_client ON crm.client_portal_users (client_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_client_portal_users_tenant_email ON crm.client_portal_users (tenant_id, email) WHERE is_deleted = false;
