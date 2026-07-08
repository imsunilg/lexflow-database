-- Forward-reference FK hoisted here: TaskTemplateItems sorts alphabetically
-- before TaskTemplates (Build Playbook §1.1 per-object execution order), so
-- ops.task_templates doesn't exist yet when TaskTemplateItems' own
-- 003_Constraints.sql would otherwise run.
ALTER TABLE ops.task_template_items
  ADD CONSTRAINT fk_task_template_items_template FOREIGN KEY (template_id) REFERENCES ops.task_templates (id);
