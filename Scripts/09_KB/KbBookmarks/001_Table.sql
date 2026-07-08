-- PROMPT DB-9. PRD Module 12 (kb_bookmarks): "bookmarks (personal)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- user_id FK -> core.users(id) is backward-safe and added below.
-- kb_ref_id is polymorphic (kb_ref_kind selects which KB content type it
-- points at) so it is intentionally not FK'd to any single table — same
-- pattern as ops.event_reminders.event_ref_id.
CREATE TABLE kb.kb_bookmarks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  user_id uuid NOT NULL,
  kb_ref_kind text NOT NULL,
  kb_ref_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
