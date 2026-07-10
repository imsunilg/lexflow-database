-- Additive to 04_Legal, added after DB-4 had already been applied (DbUp journals
-- by script name, not content hash). PRD Module 5 Database Tables lists
-- case_stage_history alongside court_cases/hearings/etc., but it wasn't built in
-- the original DB-4 pass — POST /cases/{id}/stage needs somewhere to record the
-- stage-transition audit trail, same shape/role as crm.lead_stage_history.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- case_id FK: legal.court_cases already exists (same-session additive migration,
-- not part of the original alphabetical build sequence), so it's a normal direct
-- FK below — no hoisting needed.
CREATE TABLE legal.case_stage_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  case_id uuid NOT NULL,
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

ALTER TABLE legal.case_stage_history
  ADD CONSTRAINT fk_case_stage_history_case FOREIGN KEY (case_id) REFERENCES legal.court_cases (id);

ALTER TABLE legal.case_stage_history
  ADD CONSTRAINT fk_case_stage_history_by_user FOREIGN KEY (by_user) REFERENCES core.users (id);

CREATE INDEX ix_case_stage_history_tenant ON legal.case_stage_history (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_case_stage_history_case ON legal.case_stage_history (case_id, at DESC) WHERE is_deleted = false;
