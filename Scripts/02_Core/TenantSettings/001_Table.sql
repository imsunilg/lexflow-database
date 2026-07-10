-- PRD §18/Module 15 ("Tables. tenant_settings(key, value_json, updated_by,
-- updated_at)"). Backs the 11 Settings sections (§Module 15) that have no
-- dedicated typed table of their own (Firm Details, Branding, Theme, SMTP,
-- SMS Gateway, WhatsApp API, Payment Gateways non-secret config, Document
-- Templates, Business hours & holidays, Data/retention display settings,
-- Security settings) — the other 4 sections (Taxes, Number Series, Email
-- Templates, Workflow Rules) already have typed tables built in earlier
-- prompts: fin.tax_configs, fin.number_series, comm.comm_templates,
-- ops.workflow_rules.
--
-- Composite PK (tenant_id, key) — one row per section per tenant, upserted
-- by PUT /api/v1/settings/{section}. Expanded to the full audit trio (§14
-- binding convention) beyond the PRD's abbreviated sketch, matching every
-- other table in this repo.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
CREATE TABLE core.tenant_settings (
  tenant_id uuid NOT NULL,
  key text NOT NULL,
  value_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid,
  PRIMARY KEY (tenant_id, key)
);
