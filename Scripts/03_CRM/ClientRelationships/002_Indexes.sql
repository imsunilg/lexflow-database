CREATE INDEX ix_client_relationships_tenant ON crm.client_relationships (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_client_relationships_client ON crm.client_relationships (client_id) WHERE is_deleted = false;

CREATE INDEX ix_client_relationships_related_client ON crm.client_relationships (related_client_id) WHERE is_deleted = false;
