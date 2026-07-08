-- PROMPT DB-6. PRD §18 (fin.running_timers(user_id PK, matter_id FK NULL,
-- started_at, paused_ms bigint, context jsonb)), Module 9: "Only one running
-- timer per user; starting another auto-pauses first ... Timer survives
-- refresh/app close (server-anchored start timestamp; heartbeat)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- user_id FK -> core.users(id), matter_id FK -> legal.matters(id) are both
-- backward-safe (02_Core / 04_Legal already built) and added below.
CREATE TABLE fin.running_timers (
  user_id uuid PRIMARY KEY,
  tenant_id uuid NOT NULL,
  matter_id uuid,
  started_at timestamptz NOT NULL DEFAULT now(),
  paused_ms bigint NOT NULL DEFAULT 0,
  context jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid
);
