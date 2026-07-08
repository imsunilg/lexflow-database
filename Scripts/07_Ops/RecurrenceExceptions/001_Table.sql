-- PROMPT DB-7. PRD Module 6 (recurrence_exceptions): "exceptions
-- (edit/delete this-occurrence vs series)"; AC-CAL3: "Editing 'this
-- occurrence only' leaves series intact (exception row created)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- event_id FK -> ops.calendar_events(id) is backward-safe (CalendarEvents
-- already built) and added below — points at the recurring series' master
-- event.
CREATE TABLE ops.recurrence_exceptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  event_id uuid NOT NULL,
  occurrence_date date NOT NULL,
  exception_type text NOT NULL,
  override_starts_at timestamptz,
  override_ends_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
