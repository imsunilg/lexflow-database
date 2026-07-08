CREATE INDEX ix_trust_accounts_tenant ON fin.trust_accounts (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_trust_accounts_client ON fin.trust_accounts (client_id) WHERE is_deleted = false;
