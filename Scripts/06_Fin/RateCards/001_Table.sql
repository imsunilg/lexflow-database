-- PROMPT DB-6. PRD Module 8 (rate_cards): "rate card: default firm rates by
-- role, matter-level overrides per timekeeper".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- branch_id FK -> core.branches(id) is backward-safe (02_Core already
-- built) and added below.
CREATE TABLE fin.rate_cards (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  name text NOT NULL,
  branch_id uuid,
  is_default boolean NOT NULL DEFAULT false,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
