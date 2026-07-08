-- PROMPT DB-15. PRD Module 13 Database: "rpt_dim_date/lawyer/client/
-- practice_area (refreshed hourly incremental)"; edge case: "deleted
-- lawyer in history (dim retains, marked inactive)".
--
-- POPULATION OWNERSHIP: populated and kept current by an hourly
-- incremental job in LexFlow.Workers (a later API-phase prompt) — no seed
-- script for it exists here. The job upserts by lawyer_key (=
-- core.users.id) and never hard-deletes a row even after the source user
-- is deactivated/deleted, per the edge case above — it flips is_active
-- instead, so historical facts (e.g. a closed matter's responsible lawyer)
-- keep resolving to a name.
--
-- No FK anywhere — see rpt.rpt_dim_client/001_Table.sql for why this
-- schema skips physical FKs throughout.
CREATE TABLE rpt.rpt_dim_lawyer (
  lawyer_key uuid PRIMARY KEY,
  tenant_id uuid NOT NULL,
  name text,
  role_key text,
  branch_id uuid,
  department_id uuid,
  is_active boolean NOT NULL DEFAULT true,
  updated_at timestamptz NOT NULL DEFAULT now()
);
