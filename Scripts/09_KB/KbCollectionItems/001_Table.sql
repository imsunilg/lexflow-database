-- PROMPT DB-9. PRD Module 12 (kb_collection_items): "collections (curated
-- sets e.g. 'Cheque bounce defense pack')".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- collection_id FK -> kb.kb_collections(id) is forward (KbCollections sorts
-- alphabetically after KbCollectionItems) — added in
-- 09_KB/KbCollections/003_Constraints.sql instead.
-- kb_ref_id is polymorphic, not FK'd — same pattern as kb.kb_bookmarks.
CREATE TABLE kb.kb_collection_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  collection_id uuid NOT NULL,
  kb_ref_kind text NOT NULL,
  kb_ref_id uuid NOT NULL,
  sort_order int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
