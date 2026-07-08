-- PROMPT DB-3. PRD §18 (crm.lead_stage_history), Module 2 ("Stage transitions
-- recorded with timestamps for velocity analytics").
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- lead_id FK: added in 03_CRM/Leads/003_Constraints.sql, not here — Leads
-- sorts alphabetically after LeadStageHistory (Build Playbook §1.1 per-object
-- execution order), so crm.leads doesn't exist yet at this point.
CREATE TABLE crm.lead_stage_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  lead_id uuid NOT NULL,
  from_stage text,
  to_stage text NOT NULL,
  at timestamptz NOT NULL DEFAULT now(),
  by_user uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
