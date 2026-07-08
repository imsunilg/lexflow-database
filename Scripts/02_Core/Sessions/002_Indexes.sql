CREATE INDEX ix_user_sessions_tenant ON core.user_sessions (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_user_sessions_user ON core.user_sessions (user_id) WHERE is_deleted = false;

CREATE INDEX ix_user_sessions_family ON core.user_sessions (family_id);
