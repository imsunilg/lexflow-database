-- PROMPT DB-8. PRD §18 (comm.whatsapp_messages(client_id, wa_msg_id UNIQUE,
-- direction, template_id, body, media_document_id, status,
-- window_expires_at)), Module 11: "session messages (24-h window) +
-- approved template messages (HSM) ... opt-in tracked per client".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- client_id FK -> crm.clients(id) is backward-safe and added below.
-- template_id FK -> comm.comm_templates(id) is backward-safe (CommTemplates
-- already built) and added below.
-- media_document_id FK -> dms.documents(id) is backward-safe — 08_Comm runs
-- entirely after 05_DMS in the top-level numeric folder order.
CREATE TABLE comm.whatsapp_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  client_id uuid,
  wa_msg_id text NOT NULL,
  direction text NOT NULL,
  template_id uuid,
  body text,
  media_document_id uuid,
  status text NOT NULL DEFAULT 'Queued',
  window_expires_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
