-- PROMPT DB-7. PRD Module 10 (task_template_items): "task-plan templates
-- per matter type (e.g., 'New Civil Suit': 12 predefined tasks with
-- relative due dates from matter open/filing date)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- template_id FK -> ops.task_templates(id) is forward (TaskTemplates sorts
-- alphabetically after TaskTemplateItems) — added in
-- 07_Ops/TaskTemplates/003_Constraints.sql instead.
CREATE TABLE ops.task_template_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  template_id uuid NOT NULL,
  title text NOT NULL,
  relative_due_days int NOT NULL DEFAULT 0,
  category text,
  sort_order int NOT NULL DEFAULT 0,
  is_mandatory boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
