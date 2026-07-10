CREATE INDEX ix_report_definitions_tenant ON rpt.report_definitions (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_report_definitions_owner ON rpt.report_definitions (tenant_id, owner_id) WHERE is_deleted = false;
