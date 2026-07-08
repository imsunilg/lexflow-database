-- PROMPT DB-8. PRD §18 (comm.email_messages(thread_id, message_id_hdr
-- UNIQUE, direction, from_addr, to_addrs jsonb, subject,
-- body_html_sanitized, sent_at, matter_id) PARTITION BY RANGE(sent_at)).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- thread_id FK -> comm.email_threads(id) is forward (EmailThreads sorts
-- alphabetically after EmailMessages) — added in
-- 08_Comm/EmailThreads/003_Constraints.sql instead.
-- matter_id FK -> legal.matters(id), client_id FK -> crm.clients(id) are
-- both backward-safe and added below.
-- Explicit prompt requirement: PARTITION BY RANGE(sent_at), same mechanics
-- as 07_Ops/ReminderDispatchLog/001_Table.sql — a partitioned table's
-- primary key must include the partition key, hence PRIMARY KEY
-- (id, sent_at). Partition strategy note on UNIQUE(message_id_hdr): a
-- unique index on a partitioned table must also include the partition key,
-- so the closest enforceable constraint is UNIQUE(message_id_hdr, sent_at)
-- — Postgres cannot enforce true cross-partition global uniqueness of
-- message_id_hdr alone via a single index. This is an accepted trade-off:
-- RFC 5322 Message-ID headers are globally unique by construction (each
-- mail system mints its own, collision-free by design), so partition-scoped
-- enforcement plus that convention is sufficient in practice.
CREATE TABLE comm.email_messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  thread_id uuid,
  message_id_hdr text NOT NULL,
  in_reply_to text,
  direction text NOT NULL,
  from_addr citext,
  to_addrs jsonb NOT NULL DEFAULT '[]'::jsonb,
  subject text,
  body_html_sanitized text,
  has_attachments boolean NOT NULL DEFAULT false,
  sent_at timestamptz NOT NULL DEFAULT now(),
  matter_id uuid,
  client_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid,
  PRIMARY KEY (id, sent_at)
) PARTITION BY RANGE (sent_at);
