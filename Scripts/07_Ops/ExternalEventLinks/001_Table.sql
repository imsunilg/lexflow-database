-- PROMPT DB-7. PRD Module 6 (external_event_links): "map native↔external
-- ids, etag, last_synced".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- event_id FK -> ops.calendar_events(id) and external_account_id FK ->
-- ops.external_calendar_accounts(id) are both backward-safe (CalendarEvents
-- / ExternalCalendarAccounts already built) and added below.
CREATE TABLE ops.external_event_links (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  event_id uuid NOT NULL,
  external_account_id uuid NOT NULL,
  external_event_id text NOT NULL,
  etag text,
  last_synced_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
