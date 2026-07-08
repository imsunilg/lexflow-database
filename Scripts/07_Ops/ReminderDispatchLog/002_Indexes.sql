-- CREATE INDEX on a partitioned table propagates to every existing
-- partition and to every partition created later via PARTITION OF.
CREATE INDEX ix_reminder_dispatch_log_tenant ON ops.reminder_dispatch_log (tenant_id);

CREATE INDEX ix_reminder_dispatch_log_reminder ON ops.reminder_dispatch_log (reminder_id);
