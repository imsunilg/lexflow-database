-- PROMPT DB-7. PRD §18 (ops.workflow_runs(rule_id, trigger_ref, status,
-- executed_at, result jsonb)), §23: "each run logged (workflow_runs) with
-- input snapshot + action results; retries 3×".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- rule_id FK -> ops.workflow_rules(id) is backward-safe (WorkflowRules
-- already built) and added below.
CREATE TABLE ops.workflow_runs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  rule_id uuid NOT NULL,
  trigger_ref text,
  status text NOT NULL DEFAULT 'Pending',
  executed_at timestamptz,
  result jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
