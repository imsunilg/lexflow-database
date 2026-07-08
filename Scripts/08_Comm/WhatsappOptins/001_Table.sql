-- PROMPT DB-8. PRD Module 11 (whatsapp_optins): "opt-in tracked per client
-- (mandatory before first template send)"; edge case: "WhatsApp number
-- changes (history preserved, new opt-in required)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- client_id FK -> crm.clients(id) is backward-safe and added below.
CREATE TABLE comm.whatsapp_optins (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  client_id uuid NOT NULL,
  phone_e164 text NOT NULL,
  opted_in_at timestamptz NOT NULL DEFAULT now(),
  opted_out_at timestamptz,
  source text,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
