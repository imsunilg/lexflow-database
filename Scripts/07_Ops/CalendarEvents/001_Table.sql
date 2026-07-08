-- PROMPT DB-7. PRD §18 (ops.calendar_events(kind, title, starts_at, ends_at,
-- all_day, location, video_link, matter_id, rrule, series_id, organizer_id)),
-- Module 6: native events; hearings/tasks/deadlines are projected in via the
-- view v_calendar_items (11_Views, not this object).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- matter_id FK -> legal.matters(id), organizer_id FK -> core.users(id) are
-- backward-safe (04_Legal / 02_Core already built) and added below.
-- series_id is self-referencing (added below — same-object self-reference,
-- no ordering issue): it points at the master event of a recurring series;
-- NULL on a non-recurring event or on the master event itself.
CREATE TABLE ops.calendar_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  kind text NOT NULL,
  title text NOT NULL,
  starts_at timestamptz NOT NULL,
  ends_at timestamptz NOT NULL,
  all_day boolean NOT NULL DEFAULT false,
  location text,
  video_link text,
  matter_id uuid,
  rrule text,
  series_id uuid,
  organizer_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
