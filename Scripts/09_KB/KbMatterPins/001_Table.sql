-- PROMPT DB-9. PRD §18 / Module 12 (kb_matter_pins(matter_id, kb_ref,
-- note)): "pin-to-matter (cite a KB item into a matter's Arguments/
-- Research tab with pin note)"; edge case: "orphan pins after KB item
-- unpublish (pin retains snapshot text)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- matter_id FK -> legal.matters(id), pinned_by FK -> core.users(id) are
-- both backward-safe (04_Legal / 02_Core already built) and added below.
-- kb_ref_id is polymorphic, not FK'd — same pattern as kb.kb_bookmarks.
-- snapshot_text freezes the cited content at pin time so the pin survives
-- the KB item later being unpublished or edited (per the edge case above).
CREATE TABLE kb.kb_matter_pins (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  matter_id uuid NOT NULL,
  kb_ref_kind text NOT NULL,
  kb_ref_id uuid NOT NULL,
  note text,
  snapshot_text text,
  pinned_by uuid,
  pinned_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
