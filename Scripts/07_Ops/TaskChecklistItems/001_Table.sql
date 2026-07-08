-- PROMPT DB-7. PRD Module 10 (task_checklist_items): "checklist items ...
-- done requires all 'mandatory' checklist items ticked (flag per item)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- task_id FK: added in 07_Ops/Tasks/003_Constraints.sql, not here — Tasks
-- sorts alphabetically after TaskChecklistItems.
CREATE TABLE ops.task_checklist_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  task_id uuid NOT NULL,
  label text NOT NULL,
  is_done boolean NOT NULL DEFAULT false,
  is_mandatory boolean NOT NULL DEFAULT false,
  sort_order int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
