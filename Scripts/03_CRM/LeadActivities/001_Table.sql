-- PROMPT DB-3. PRD §18 (crm.lead_activities), Module 2 (calls/emails/meetings/notes
-- unified with activity_type).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- lead_id FK: added in 03_CRM/Leads/003_Constraints.sql, not here — Leads
-- sorts alphabetically after LeadActivities (Build Playbook §1.1 per-object
-- execution order), so crm.leads doesn't exist yet at this point.
CREATE TABLE crm.lead_activities (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  lead_id uuid NOT NULL,
  activity_type text NOT NULL,
  direction text,
  duration_min int,
  subject text,
  body text,
  outcome text,
  occurred_at timestamptz NOT NULL DEFAULT now(),
  logged_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
