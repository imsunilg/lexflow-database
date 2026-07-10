CREATE UNIQUE INDEX ux_gateway_configs_tenant_provider ON core.gateway_configs (tenant_id, provider) WHERE is_deleted = false;
