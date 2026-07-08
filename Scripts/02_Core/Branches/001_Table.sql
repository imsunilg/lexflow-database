-- PROMPT DB-2. PRD §14, §18 (core.branches).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
CREATE TABLE core.branches (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  name text NOT NULL,
  code text NOT NULL,
  address jsonb NOT NULL DEFAULT '{}'::jsonb,
  tz text NOT NULL DEFAULT 'Asia/Kolkata',
  gstin text,
  series_prefix text,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
