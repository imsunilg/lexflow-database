CREATE INDEX ix_report_runs_tenant ON rpt.report_runs (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_report_runs_requested_by ON rpt.report_runs (tenant_id, requested_by, requested_at DESC) WHERE is_deleted = false;

CREATE INDEX ix_report_runs_status ON rpt.report_runs (tenant_id, status) WHERE is_deleted = false;
