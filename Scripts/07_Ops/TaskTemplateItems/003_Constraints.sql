ALTER TABLE ops.task_template_items
  ADD CONSTRAINT ck_task_template_items_category CHECK (category IS NULL OR category IN ('Filing', 'Drafting', 'Research', 'Compliance', 'Follow-up', 'Admin'));

-- fk_task_template_items_template is added in
-- 07_Ops/TaskTemplates/003_Constraints.sql instead — TaskTemplates sorts
-- alphabetically after TaskTemplateItems.
