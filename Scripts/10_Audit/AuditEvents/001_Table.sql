-- PROMPT DB-10. PRD §18 (audit.audit_events(id, at, actor_user_id,
-- actor_type[staff|portal|system|api_key], tenant_id,
-- action[create|update|delete|read_sensitive|login|export|approve|
-- override], entity_type, entity_id, before jsonb, after jsonb, ip inet,
-- ua, trace_id) PARTITION BY RANGE(at)), §30 Audit: "Record: actor
-- (user/portal/system/api-key), tenant, action, entity type+id, before/
-- after diff (jsonb, redacted fields masked), IP, UA, traceId, at (UTC)."
--
-- No FKs anywhere on this table — §19.15: "Audit ↔ all: logical reference
-- by (entity_type, entity_id); no FKs (audit outlives entities, partitions
-- rotate to cold storage)." That includes actor_user_id: a user row could
-- be hard-purged long after their audit trail must still exist.
--
-- No audit trio (created_at/updated_at/is_deleted/...) either — this table
-- IS the audit trail; `at` is its own creation timestamp, and §30 /
-- 003_Insert_Only_Trigger.sql make it insert-only, so there is no update or
-- soft-delete lifecycle to track.
--
-- PARTITION BY RANGE(at): a partitioned table's primary key must include
-- the partition key, hence PRIMARY KEY (id, at) instead of just (id) — same
-- mechanics as 07_Ops/ReminderDispatchLog and 08_Comm/EmailMessages.
CREATE TABLE audit.audit_events (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  at timestamptz NOT NULL DEFAULT now(),
  tenant_id uuid NOT NULL,
  actor_user_id uuid,
  actor_type text NOT NULL,
  action text NOT NULL,
  entity_type text NOT NULL,
  entity_id uuid,
  before jsonb,
  after jsonb,
  ip inet,
  ua text,
  trace_id text,
  PRIMARY KEY (id, at),
  CONSTRAINT ck_audit_events_actor_type CHECK (actor_type IN ('staff', 'portal', 'system', 'api_key')),
  CONSTRAINT ck_audit_events_action CHECK (action IN ('create', 'update', 'delete', 'read_sensitive', 'login', 'export', 'approve', 'override'))
) PARTITION BY RANGE (at);
