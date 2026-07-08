CREATE INDEX ix_notifications_tenant ON ops.notifications (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_notifications_user_unread ON ops.notifications (user_id, created_at DESC) WHERE read_at IS NULL AND is_deleted = false;
