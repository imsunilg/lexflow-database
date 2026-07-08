CREATE INDEX ix_lead_activities_tenant ON crm.lead_activities (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_lead_activities_lead_occurred ON crm.lead_activities (lead_id, occurred_at DESC) WHERE is_deleted = false;

CREATE INDEX ix_lead_activities_logged_by ON crm.lead_activities (logged_by) WHERE is_deleted = false;
