-- PROMPT DB-7. PRD Module 6 (event_attendees): "attendees internal+client+
-- external emails ... attendee declines (status shown, organizer notified)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- event_id FK -> ops.calendar_events(id) and user_id FK -> core.users(id)
-- are both backward-safe (CalendarEvents / 02_Core already built) and added
-- below. user_id is nullable — external attendees are identified by email
-- only.
CREATE TABLE ops.event_attendees (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  event_id uuid NOT NULL,
  user_id uuid,
  email citext,
  name text,
  is_organizer boolean NOT NULL DEFAULT false,
  status text NOT NULL DEFAULT 'Pending',
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
