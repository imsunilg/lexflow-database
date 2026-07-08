CREATE INDEX ix_login_history_tenant ON core.login_history (tenant_id);

CREATE INDEX ix_login_history_user_at ON core.login_history (user_id, at DESC);
