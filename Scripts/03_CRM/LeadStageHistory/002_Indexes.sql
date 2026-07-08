CREATE INDEX ix_lead_stage_history_tenant ON crm.lead_stage_history (tenant_id);

CREATE INDEX ix_lead_stage_history_lead_at ON crm.lead_stage_history (lead_id, at DESC);
