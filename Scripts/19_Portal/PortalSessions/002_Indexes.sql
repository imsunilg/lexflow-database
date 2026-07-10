CREATE INDEX ix_portal_sessions_tenant ON portal.portal_sessions (tenant_id) WHERE is_deleted = false;
CREATE INDEX ix_portal_sessions_client_portal_user ON portal.portal_sessions (client_portal_user_id) WHERE is_deleted = false;
CREATE UNIQUE INDEX ux_portal_sessions_refresh_hash ON portal.portal_sessions (refresh_hash);
CREATE INDEX ix_portal_sessions_family ON portal.portal_sessions (family_id);
