-- PROMPT DB-7. PRD §18 (ops.reminder_dispatch_log(reminder_id, channel,
-- sent_at, status, provider_ref, error) PARTITION BY RANGE(sent_at)),
-- Module 6 / AC-CAL2: "dispatch log proves it" (a hearing reminder fired
-- on every enabled channel).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- reminder_id FK -> ops.event_reminders(id) is backward-safe (EventReminders
-- already built) and added below.
-- Explicit prompt requirement: PARTITION BY RANGE(sent_at). A partitioned
-- table's primary key must include the partition key, hence PRIMARY KEY
-- (id, sent_at) instead of just (id). No partitions exist yet after this
-- statement — 002_Indexes.sql / 003_Constraints.sql apply to the parent and
-- propagate to every partition (including future ones); the initial
-- partitions are created by 005_Partitions.sql via the helper function
-- defined in 004_Functions.sql.
CREATE TABLE ops.reminder_dispatch_log (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  reminder_id uuid NOT NULL,
  channel text NOT NULL,
  sent_at timestamptz NOT NULL DEFAULT now(),
  status text NOT NULL DEFAULT 'Sent',
  provider_ref text,
  error text,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid,
  PRIMARY KEY (id, sent_at)
) PARTITION BY RANGE (sent_at);
