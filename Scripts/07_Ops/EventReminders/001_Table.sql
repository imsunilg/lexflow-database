-- PROMPT DB-7. PRD §18 (ops.event_reminders(event_ref_kind, event_ref_id,
-- offset_minutes, channel, status)), Module 6: "Reminders: per-event
-- overrides on top of type-level defaults; channels Email/SMS/WhatsApp/
-- Push/In-app; hearing defaults: 7d, 1d, same-day 07:00 court-local."
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- event_ref_id is polymorphic (event_ref_kind selects which entity it
-- points at: a calendar event, hearing, matter_important_date "deadline",
-- or task) so it is intentionally not FK'd to any single table — same
-- pattern as dms.document_permissions.principal_id.
CREATE TABLE ops.event_reminders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  event_ref_kind text NOT NULL,
  event_ref_id uuid NOT NULL,
  offset_minutes int NOT NULL,
  channel text NOT NULL,
  status text NOT NULL DEFAULT 'Pending',
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
