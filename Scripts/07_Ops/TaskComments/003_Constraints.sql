ALTER TABLE ops.task_comments
  ADD CONSTRAINT fk_task_comments_author FOREIGN KEY (author_id) REFERENCES core.users (id);

-- fk_task_comments_task is added in 07_Ops/Tasks/003_Constraints.sql
-- instead — Tasks sorts alphabetically after TaskComments.
