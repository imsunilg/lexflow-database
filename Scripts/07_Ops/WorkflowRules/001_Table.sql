-- PROMPT DB-7. PRD §18 (ops.workflow_rules(name, trigger_event, conditions
-- jsonb, actions jsonb, active, run_order)), §23 Workflow Rules (Automation
-- Engine): "Rule = Trigger + Conditions + Actions, JSON-defined, versioned,
-- per-tenant, ordered."
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- No forward-referencing FKs from this object. trigger_event is left as
-- free text (not a CHECK enum) — §23 lists 12+ entity-event triggers plus
-- cron schedules and date-proximity triggers, and new automation triggers
-- are expected to be added over time without a schema migration.
CREATE TABLE ops.workflow_rules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  name text NOT NULL,
  trigger_event text NOT NULL,
  conditions jsonb NOT NULL DEFAULT '{}'::jsonb,
  actions jsonb NOT NULL DEFAULT '[]'::jsonb,
  active boolean NOT NULL DEFAULT true,
  run_order int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
