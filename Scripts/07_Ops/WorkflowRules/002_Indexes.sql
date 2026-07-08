CREATE INDEX ix_workflow_rules_tenant ON ops.workflow_rules (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_workflow_rules_trigger_active ON ops.workflow_rules (tenant_id, trigger_event, run_order) WHERE active = true AND is_deleted = false;
