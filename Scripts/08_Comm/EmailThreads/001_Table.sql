-- PROMPT DB-8. PRD Module 11 (email_threads): "two-way sync of
-- matter-relevant threads (matching by contact email → client; user
-- confirms ambiguous)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- matter_id FK -> legal.matters(id), client_id FK -> crm.clients(id) are
-- both backward-safe and added below.
-- mailbox_id FK -> comm.mailboxes(id) is forward (Mailboxes sorts
-- alphabetically after EmailThreads) — added in
-- 08_Comm/Mailboxes/003_Constraints.sql instead.
CREATE TABLE comm.email_threads (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  subject text,
  matter_id uuid,
  client_id uuid,
  mailbox_id uuid,
  last_message_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
