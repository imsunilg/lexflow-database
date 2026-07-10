CREATE INDEX ix_portal_activity_log_tenant_client_at ON portal.portal_activity_log (tenant_id, client_portal_user_id, at DESC);
