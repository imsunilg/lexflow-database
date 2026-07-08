CREATE INDEX ix_external_calendar_accounts_tenant ON ops.external_calendar_accounts (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_external_calendar_accounts_user_provider ON ops.external_calendar_accounts (user_id, provider) WHERE is_deleted = false;
