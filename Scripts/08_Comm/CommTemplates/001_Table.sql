-- PROMPT DB-8. PRD §18 / Module 11 (comm_templates(channel, name, body,
-- variables, dlt_template_id?, wa_hsm_name?)): "SMS ... templated
-- (DLT-registered templates for India compliance)"; "WhatsApp ... approved
-- template messages (HSM)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- No forward-referencing FKs from this object.
CREATE TABLE comm.comm_templates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  channel text NOT NULL,
  name text NOT NULL,
  body text NOT NULL,
  variables jsonb NOT NULL DEFAULT '[]'::jsonb,
  dlt_template_id text,
  wa_hsm_name text,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
