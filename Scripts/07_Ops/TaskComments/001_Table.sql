-- PROMPT DB-7. PRD Module 10 (task_comments): "comments with @mentions
-- (notify)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- task_id FK: added in 07_Ops/Tasks/003_Constraints.sql, not here — Tasks
-- sorts alphabetically after TaskComments.
-- author_id FK -> core.users(id) is backward-safe and added below.
CREATE TABLE ops.task_comments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  task_id uuid NOT NULL,
  author_id uuid,
  body text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
