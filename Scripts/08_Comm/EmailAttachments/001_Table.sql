-- PROMPT DB-8. PRD Module 11 (email_attachments(document_id)).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- message_id FK -> comm.email_messages(id) is forward (EmailMessages sorts
-- alphabetically after EmailAttachments) — added in
-- 08_Comm/EmailMessages/003_Constraints.sql instead. email_messages is
-- PARTITION BY RANGE(sent_at), so its only unique key is the composite
-- (id, sent_at) — a partitioned table cannot have a unique constraint on a
-- subset of columns that excludes the partition key. A FK referencing it
-- therefore has to carry the partition key column too, hence
-- message_sent_at here (populated from the parent row at insert time).
-- document_id FK -> dms.documents(id) is backward-safe — 08_Comm runs
-- entirely after 05_DMS in the top-level numeric folder order.
CREATE TABLE comm.email_attachments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  message_id uuid NOT NULL,
  message_sent_at timestamptz NOT NULL,
  document_id uuid,
  filename text NOT NULL,
  size_bytes bigint,
  mime text,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
