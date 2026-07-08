ALTER TABLE ops.task_assignees
  ADD CONSTRAINT ck_task_assignees_role CHECK (role IN ('owner', 'collaborator', 'watcher'));

ALTER TABLE ops.task_assignees
  ADD CONSTRAINT fk_task_assignees_user FOREIGN KEY (user_id) REFERENCES core.users (id);

-- fk_task_assignees_task is added in 07_Ops/Tasks/003_Constraints.sql
-- instead — Tasks sorts alphabetically after TaskAssignees.
