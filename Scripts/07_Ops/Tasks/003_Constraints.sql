ALTER TABLE ops.tasks
  ADD CONSTRAINT ck_tasks_status CHECK (status IN ('New', 'InProgress', 'InReview', 'Done', 'Cancelled'));

ALTER TABLE ops.tasks
  ADD CONSTRAINT ck_tasks_priority CHECK (priority IN ('Low', 'Medium', 'High', 'Urgent'));

ALTER TABLE ops.tasks
  ADD CONSTRAINT ck_tasks_category CHECK (category IS NULL OR category IN ('Filing', 'Drafting', 'Research', 'Compliance', 'Follow-up', 'Admin'));

ALTER TABLE ops.tasks
  ADD CONSTRAINT ck_tasks_progress_pct_range CHECK (progress_pct BETWEEN 0 AND 100);

ALTER TABLE ops.tasks
  ADD CONSTRAINT fk_tasks_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

ALTER TABLE ops.tasks
  ADD CONSTRAINT fk_tasks_client FOREIGN KEY (client_id) REFERENCES crm.clients (id);

ALTER TABLE ops.tasks
  ADD CONSTRAINT fk_tasks_owner FOREIGN KEY (owner_id) REFERENCES core.users (id);

-- Forward-reference FKs hoisted here: TaskAssignees, TaskChecklistItems,
-- TaskComments, and TaskDependencies all sort alphabetically before Tasks
-- (Build Playbook §1.1 per-object execution order), so ops.tasks doesn't
-- exist yet when each of those objects' own 003_Constraints.sql would
-- otherwise run.
ALTER TABLE ops.task_assignees
  ADD CONSTRAINT fk_task_assignees_task FOREIGN KEY (task_id) REFERENCES ops.tasks (id);

ALTER TABLE ops.task_checklist_items
  ADD CONSTRAINT fk_task_checklist_items_task FOREIGN KEY (task_id) REFERENCES ops.tasks (id);

ALTER TABLE ops.task_comments
  ADD CONSTRAINT fk_task_comments_task FOREIGN KEY (task_id) REFERENCES ops.tasks (id);

ALTER TABLE ops.task_dependencies
  ADD CONSTRAINT fk_task_dependencies_task FOREIGN KEY (task_id) REFERENCES ops.tasks (id);

ALTER TABLE ops.task_dependencies
  ADD CONSTRAINT fk_task_dependencies_depends_on FOREIGN KEY (depends_on_task_id) REFERENCES ops.tasks (id);
