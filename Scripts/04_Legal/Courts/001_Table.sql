-- PROMPT DB-4. PRD §18 (legal.courts), Module 5 (master list — seeded per
-- tenant in 16_Seed/003_Courts_India.sql, per the Build Playbook).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
CREATE TABLE legal.courts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  name text NOT NULL,
  level text NOT NULL,
  city text,
  state text,
  bench text,
  tz text NOT NULL DEFAULT 'Asia/Kolkata',
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
