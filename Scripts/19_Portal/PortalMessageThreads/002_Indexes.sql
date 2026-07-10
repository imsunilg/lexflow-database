CREATE INDEX ix_portal_message_threads_tenant_matter ON portal.portal_message_threads (tenant_id, matter_id) WHERE is_deleted = false;
