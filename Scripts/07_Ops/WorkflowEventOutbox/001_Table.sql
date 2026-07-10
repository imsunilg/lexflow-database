-- Additive to 07_Ops, added after DB-7 had already been applied (DbUp journals by
-- script name, not content hash). §23 Workflow Rules (Automation Engine) explicitly
-- asks for "event -> outbox -> Service Bus -> workflow engine worker" execution —
-- that outbox table wasn't part of the original DB-7 pass (the PRD's own §18 table
-- list predates this specific implementation-pattern requirement). Same shape as
-- dms.document_index_outbox (05_DMS/DocumentIndexOutbox/001_Table.sql): a row is
-- written in the same transaction as the domain mutation that raised the event, a
-- background dispatcher (standing in for Service Bus, same simplification as DMS)
-- polls Pending rows and runs matching ops.workflow_rules against the payload.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- No FK on entity_id — event_type selects which entity/module it came from
-- (lead.created, matter.created, hearing.outcome_recorded, task.overdue, ...),
-- same polymorphic-reference pattern as ops.event_reminders.event_ref_id.
CREATE TABLE ops.workflow_event_outbox (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  event_type text NOT NULL,
  entity_id uuid,
  payload jsonb NOT NULL DEFAULT '{}'::jsonb,
  status text NOT NULL DEFAULT 'Pending',
  attempts int NOT NULL DEFAULT 0,
  last_error text,
  created_at timestamptz NOT NULL DEFAULT now(),
  dispatched_at timestamptz,
  processed_at timestamptz,
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);

ALTER TABLE ops.workflow_event_outbox
  ADD CONSTRAINT ck_workflow_event_outbox_status CHECK (status IN ('Pending', 'Dispatched', 'Done', 'Failed'));

CREATE INDEX ix_workflow_event_outbox_tenant ON ops.workflow_event_outbox (tenant_id) WHERE is_deleted = false;

-- The dispatcher's core query: "give me pending work, oldest first."
CREATE INDEX ix_workflow_event_outbox_pending ON ops.workflow_event_outbox (created_at) WHERE status = 'Pending' AND is_deleted = false;
