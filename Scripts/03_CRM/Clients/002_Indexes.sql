CREATE INDEX ix_clients_tenant ON crm.clients (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_clients_tenant_number ON crm.clients (tenant_id, number) WHERE is_deleted = false;

CREATE INDEX ix_clients_owner ON crm.clients (owner_id) WHERE is_deleted = false;

CREATE INDEX ix_clients_branch ON crm.clients (branch_id) WHERE is_deleted = false;

CREATE INDEX ix_clients_source_lead ON crm.clients (source_lead_id) WHERE is_deleted = false;

CREATE INDEX ix_clients_phone_trgm ON crm.clients USING gin (phone_e164 gin_trgm_ops) WHERE is_deleted = false;

CREATE INDEX ix_clients_display_name_trgm ON crm.clients USING gin (display_name gin_trgm_ops) WHERE is_deleted = false;
