CREATE INDEX ix_leads_tenant ON crm.leads (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_leads_tenant_number ON crm.leads (tenant_id, number) WHERE is_deleted = false;

-- FR duplicate rule (Module 2 Error Handling: "Duplicate on unique (tenant,
-- normalized_phone, open-stage) → 409 with existing lead ref"; PRD §18
-- literally spells this out as UNIQUE(tenant_id, phone_e164) WHERE status='Open').
CREATE UNIQUE INDEX ux_leads_tenant_phone_open ON crm.leads (tenant_id, phone_e164)
  WHERE status = 'Open' AND is_deleted = false;

CREATE INDEX ix_leads_owner_stage ON crm.leads (tenant_id, owner_id, stage) WHERE status = 'Open' AND is_deleted = false;

CREATE INDEX ix_leads_source ON crm.leads (source_id) WHERE is_deleted = false;

CREATE INDEX ix_leads_branch ON crm.leads (branch_id) WHERE is_deleted = false;

CREATE INDEX ix_leads_lost_reason ON crm.leads (lost_reason_id) WHERE is_deleted = false;

CREATE INDEX ix_leads_converted_client ON crm.leads (converted_client_id) WHERE is_deleted = false;
