-- PROMPT DB-3. PRD §14, §18, Module 2 (lead capture sources — web-to-lead, referral, etc.).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql for why
-- (DbUp applies scripts in full path order; per-object folders execute
-- alphabetically per object per top-level folder, so no schema here can FK to
-- core.tenants without breaking apply order).
CREATE TABLE crm.lead_sources (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  name text NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
