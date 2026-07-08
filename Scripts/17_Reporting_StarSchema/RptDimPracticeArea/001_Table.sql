-- PROMPT DB-15. PRD Module 13 Database: "rpt_dim_date/lawyer/client/
-- practice_area (refreshed hourly incremental)".
--
-- POPULATION OWNERSHIP: populated and kept current by an hourly
-- incremental job in LexFlow.Workers (a later API-phase prompt) — no seed
-- script for it exists here. Upserted by practice_area_key (=
-- legal.practice_areas.id); never hard-deleted, same retained-history
-- reasoning as rpt.rpt_dim_lawyer.
--
-- No FK anywhere — see rpt.rpt_dim_client/001_Table.sql for why this
-- schema skips physical FKs throughout. parent_key mirrors
-- legal.practice_areas.parent_id but, like every other column here, is a
-- plain denormalized copy, not a self-referencing constraint.
CREATE TABLE rpt.rpt_dim_practice_area (
  practice_area_key uuid PRIMARY KEY,
  tenant_id uuid NOT NULL,
  name text,
  parent_key uuid,
  is_active boolean NOT NULL DEFAULT true,
  updated_at timestamptz NOT NULL DEFAULT now()
);
