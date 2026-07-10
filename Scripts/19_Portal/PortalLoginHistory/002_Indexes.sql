CREATE INDEX ix_portal_login_history_tenant_user_at ON portal.portal_login_history (tenant_id, client_portal_user_id, at DESC) WHERE is_deleted = false;
