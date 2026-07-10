CREATE INDEX ix_report_schedules_tenant ON rpt.report_schedules (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_report_schedules_due ON rpt.report_schedules (next_run_at) WHERE is_deleted = false AND is_active = true;
