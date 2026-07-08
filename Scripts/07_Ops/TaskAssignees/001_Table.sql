-- PROMPT DB-7. PRD Module 10 (task_assignees(role[owner|collaborator|
-- watcher])).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- task_id FK: added in 07_Ops/Tasks/003_Constraints.sql, not here — Tasks
-- sorts alphabetically after TaskAssignees (Build Playbook §1.1 per-object
-- execution order), so ops.tasks doesn't exist yet here.
-- user_id FK -> core.users(id) is backward-safe and added below.
CREATE TABLE ops.task_assignees (
  tenant_id uuid NOT NULL,
  task_id uuid NOT NULL,
  user_id uuid NOT NULL,
  role text NOT NULL DEFAULT 'collaborator',
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid,
  PRIMARY KEY (task_id, user_id)
);
