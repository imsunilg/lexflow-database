CREATE INDEX ix_portal_messages_thread_created ON portal.portal_messages (thread_id, created_at) WHERE is_deleted = false;
CREATE INDEX ix_portal_messages_tenant ON portal.portal_messages (tenant_id) WHERE is_deleted = false;
