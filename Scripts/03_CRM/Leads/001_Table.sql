-- PROMPT DB-3. PRD §14, §18 (crm.leads), Module 2.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- stage is intentionally NOT CHECK-constrained: pipeline stages are
-- tenant-configurable (Module 2 "Pipeline (default stages, configurable)"),
-- unlike status which is a fixed system lifecycle.
-- practice_area_id: FK to legal.practice_areas(id) deferred — 04_Legal hasn't
-- been built yet (it runs after 03_CRM); the FK will be added when
-- 04_Legal/PracticeAreas is built, following the same hoisting pattern used
-- throughout this schema (see 02_Core/Users/003_Constraints.sql).
CREATE TABLE crm.leads (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  number text NOT NULL,
  first_name text NOT NULL,
  last_name text,
  company text,
  email citext,
  phone_e164 text,
  source_id uuid,
  stage text NOT NULL DEFAULT 'New',
  owner_id uuid,
  branch_id uuid,
  practice_area_id uuid,
  score int NOT NULL DEFAULT 0,
  issue_summary text,
  opposing_party text,
  budget_band text,
  status text NOT NULL DEFAULT 'Open',
  lost_reason_id uuid,
  converted_client_id uuid,
  sla_first_contact_due timestamptz,
  first_contacted_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
