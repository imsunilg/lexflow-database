CREATE INDEX ix_workflow_runs_tenant ON ops.workflow_runs (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_workflow_runs_rule ON ops.workflow_runs (rule_id, executed_at DESC) WHERE is_deleted = false;
