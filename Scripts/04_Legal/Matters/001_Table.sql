-- PROMPT DB-4. PRD §14, §18 (legal.matters), Module 4.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- client_id FK -> crm.clients(id), branch_id FK -> core.branches(id) and
-- responsible_lawyer_id FK -> core.users(id) are all backward (02_Core and
-- 03_CRM are built before 04_Legal) and are added normally in this object's
-- own 003_Constraints.sql.
-- practice_area_id FK: added in 04_Legal/PracticeAreas/003_Constraints.sql,
-- not here — PracticeAreas sorts alphabetically after Matters (Build
-- Playbook §1.1 per-object execution order), so legal.practice_areas doesn't
-- exist yet at this point.
CREATE TABLE legal.matters (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  number text NOT NULL,
  title text NOT NULL,
  client_id uuid NOT NULL,
  matter_type text NOT NULL,
  practice_area_id uuid,
  branch_id uuid,
  responsible_lawyer_id uuid,
  priority text NOT NULL DEFAULT 'Medium',
  status text NOT NULL DEFAULT 'Open',
  outcome text,
  opened_on date NOT NULL DEFAULT current_date,
  closed_on date,
  is_private boolean NOT NULL DEFAULT false,
  budget numeric(18, 2),
  description text,
  billing_arrangement jsonb NOT NULL DEFAULT '{}'::jsonb,
  ai_allowed boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
