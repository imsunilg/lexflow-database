-- PROMPT DB-9. PRD Module 12 (kb_item_tags(polymorphic)): "taxonomy tags
-- (practice area, legal issue)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- tag_id FK -> kb.kb_tags(id) is forward (KbTags sorts alphabetically
-- after KbItemTags) — added in 09_KB/KbTags/003_Constraints.sql instead.
-- kb_ref_id is polymorphic, not FK'd — same pattern as kb.kb_bookmarks.
CREATE TABLE kb.kb_item_tags (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  tag_id uuid NOT NULL,
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
