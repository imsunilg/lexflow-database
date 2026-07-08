-- PROMPT DB-2. PRD §14, §18 (core.users), §20 (AuthN/token claims), Module 14.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- email uses citext for case-insensitive uniqueness (extension enabled in
-- 00_Extensions/001_Enable_Extensions.sql).
-- branch_id/department_id FKs live in 003_Constraints.sql, not inline here,
-- per the per-object numbering rule (FKs belong in 003_Constraints.sql).
CREATE TABLE core.users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  email citext NOT NULL,
  password_hash text,
  name text NOT NULL,
  designation text,
  bar_enrollment_no text,
  phone text,
  photo_blob_path text,
  signature_blob_path text,
  cost_rate numeric(18, 2),
  branch_id uuid,
  department_id uuid,
  status text NOT NULL DEFAULT 'Invited',
  tz text,
  locale text,
  two_fa_secret bytea,
  two_fa_enabled boolean NOT NULL DEFAULT false,
  notification_prefs jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
