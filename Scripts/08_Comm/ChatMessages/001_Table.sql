-- PROMPT DB-8. PRD Module 11 (chat_messages): "message → task conversion;
-- file share (DMS-backed); SignalR real-time".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- channel_id FK -> comm.chat_channels(id), sender_id FK -> core.users(id)
-- are both backward-safe (ChatChannels / 02_Core already built) and added
-- below. task_id FK -> ops.tasks(id) and document_id FK -> dms.documents(id)
-- are backward-safe too — 08_Comm runs entirely after 05_DMS and 07_Ops in
-- the top-level numeric folder order.
-- Explicit prompt requirement: "a simple sequence-based ordering column for
-- pagination" — seq is a plain identity column (globally monotonic across
-- all channels), sufficient for stable keyset pagination (WHERE channel_id
-- = ? AND seq > ? ORDER BY seq) without the per-partition running-counter
-- complexity used for fin.trust_ledger_entries.entry_no (that case needed
-- a number restarting per account; chat pagination just needs total order).
CREATE TABLE comm.chat_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  channel_id uuid NOT NULL,
  sender_id uuid,
  body text,
  seq bigint GENERATED ALWAYS AS IDENTITY,
  task_id uuid,
  document_id uuid,
  sent_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
