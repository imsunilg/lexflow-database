-- PROMPT DB-8. PRD Module 11 (call_logs): "manual log (direction, duration,
-- summary, follow-up task quick-create); click-to-call via Twilio Voice
-- (optional) with recording (consent banner per jurisdiction setting) and
-- auto-log."
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- client_id FK -> crm.clients(id), matter_id FK -> legal.matters(id),
-- user_id FK -> core.users(id) are all backward-safe (03_CRM / 04_Legal /
-- 02_Core already built) and added below.
-- follow_up_task_id FK -> ops.tasks(id) is backward-safe too — 08_Comm runs
-- entirely after 07_Ops in the top-level numeric folder order, so
-- ops.tasks already exists.
CREATE TABLE comm.call_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  client_id uuid,
  matter_id uuid,
  user_id uuid,
  direction text NOT NULL,
  duration_sec int NOT NULL DEFAULT 0,
  summary text,
  follow_up_task_id uuid,
  recording_blob_path text,
  consent_given boolean NOT NULL DEFAULT false,
  provider text,
  provider_call_id text,
  occurred_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
