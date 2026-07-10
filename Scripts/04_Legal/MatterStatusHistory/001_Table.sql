-- Additive to 04_Legal, added after DB-4 had already been applied (DbUp journals
-- by script name, not content hash). PRD Module 4 Database Tables lists
-- matter_status_history alongside matters/matter_team_members/etc., but it wasn't
-- built in the original DB-4 pass — POST /matters/{id}/status needs somewhere to
-- record the audit trail of status transitions (outcome, closure note), same
-- shape/role as crm.lead_stage_history for leads.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- matter_id FK: legal.matters already exists (this is a same-session additive
-- migration, not part of the original alphabetical build sequence), so it's a
-- normal direct FK below — no hoisting needed.
CREATE TABLE legal.matter_status_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  matter_id uuid NOT NULL,
  from_status text,
  to_status text NOT NULL,
  outcome text,
  closure_note text,
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

ALTER TABLE legal.matter_status_history
  ADD CONSTRAINT fk_matter_status_history_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

ALTER TABLE legal.matter_status_history
  ADD CONSTRAINT fk_matter_status_history_by_user FOREIGN KEY (by_user) REFERENCES core.users (id);

CREATE INDEX ix_matter_status_history_tenant ON legal.matter_status_history (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_matter_status_history_matter ON legal.matter_status_history (matter_id, at DESC) WHERE is_deleted = false;
