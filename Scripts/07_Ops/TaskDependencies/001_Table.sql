-- PROMPT DB-7. PRD §18 (ops.task_dependencies(task_id, depends_on_task_id,
-- PK(task_id, depends_on_task_id))), Module 10: "Dependencies: finish-to-
-- start links; dependent task auto-blocked until predecessor done; circular
-- refs rejected" (AC-TK2). task_id depends_on depends_on_task_id, i.e.
-- task_id is blocked until depends_on_task_id is Done.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- Both FKs (task_id, depends_on_task_id -> ops.tasks(id)) are added in
-- 07_Ops/Tasks/003_Constraints.sql, not here — Tasks sorts alphabetically
-- after TaskDependencies.
-- The CYCLE_DETECTED cycle-check trigger is self-contained in
-- 004_Triggers.sql (it only ever queries this same table, so it has no
-- forward-reference ordering issue).
CREATE TABLE ops.task_dependencies (
  tenant_id uuid NOT NULL,
  task_id uuid NOT NULL,
  depends_on_task_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  PRIMARY KEY (task_id, depends_on_task_id)
);
