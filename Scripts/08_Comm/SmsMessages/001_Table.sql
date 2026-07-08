-- PROMPT DB-8. PRD Module 11 (sms_messages): "Twilio (or MSG91 for India)
-- ... templated (DLT-registered templates for India compliance); inbound to
-- firm number threads into client timeline."
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- client_id FK -> crm.clients(id), matter_id FK -> legal.matters(id) are
-- both backward-safe and added below.
CREATE TABLE comm.sms_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  client_id uuid,
  matter_id uuid,
  direction text NOT NULL,
  from_number text,
  to_number text,
  body text,
  dlt_template_id text,
  provider text,
  provider_message_id text,
  status text NOT NULL DEFAULT 'Queued',
  sent_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
