-- PROMPT DB-4. PRD Module 4 Database Tables: "matter_related(matter_id,
-- related_matter_id, relation_type)"; narrative: "related matters linked
-- (typed: Appeal-of, Connected, Cross-suit)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- matter_id and related_matter_id are both self-referencing FKs onto
-- legal.matters (the same table). Both FKs are added in
-- 04_Legal/Matters/003_Constraints.sql, not here — Matters sorts
-- alphabetically after MatterRelated (Build Playbook §1.1 per-object
-- execution order), so legal.matters doesn't exist yet at this point.
CREATE TABLE legal.matter_related (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  matter_id uuid NOT NULL,
  related_matter_id uuid NOT NULL,
  relation_type text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
