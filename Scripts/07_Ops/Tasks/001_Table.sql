-- PROMPT DB-7. PRD §18 (ops.tasks(number, title, description, matter_id,
-- client_id, owner_id, due_at, priority, category, status, progress_pct,
-- recurrence_id, template_key)), Module 10.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- matter_id FK -> legal.matters(id), client_id FK -> crm.clients(id),
-- owner_id FK -> core.users(id) are all backward-safe and added below.
-- recurrence_id is a plain grouping key (not FK'd — no dedicated
-- task_recurrences object exists in this Build Playbook tree; same pattern
-- as legal.hearings.group_id for consolidated-case fan-out).
CREATE TABLE ops.tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  number text,
  title text NOT NULL,
  description text,
  matter_id uuid,
  client_id uuid,
  owner_id uuid,
  due_at timestamptz,
  priority text NOT NULL DEFAULT 'Medium',
  category text,
  status text NOT NULL DEFAULT 'New',
  progress_pct int NOT NULL DEFAULT 0,
  recurrence_id uuid,
  template_key text,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
