ALTER TABLE ops.task_dependencies
  ADD CONSTRAINT ck_task_dependencies_no_self_dependency CHECK (task_id <> depends_on_task_id);

-- fk_task_dependencies_task and fk_task_dependencies_depends_on are added in
-- 07_Ops/Tasks/003_Constraints.sql instead — Tasks sorts alphabetically
-- after TaskDependencies.
