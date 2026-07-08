-- PROMPT DB-15. PRD Module 13 Database: "heavy aggregates from
-- nightly-built star-schema tables ..., rpt_fact_time (refreshed hourly
-- incremental)"; standard report #4 Lawyer Performance: "billable hours vs
-- target, utilization %, effective rate, WIP aging, matters handled,
-- hearings attended, task on-time %."
--
-- POPULATION OWNERSHIP: populated and kept current by an hourly
-- incremental job in LexFlow.Workers (a later API-phase prompt) — no
-- backfill/ETL script for it exists here.
--
-- Grain: one row per fin.time_entries row. No FK anywhere, see
-- rpt.rpt_dim_client/001_Table.sql for why this schema skips them
-- throughout.
CREATE TABLE rpt.rpt_fact_time (
  fact_time_key uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  time_entry_id uuid NOT NULL,
  date_key int,
  lawyer_key uuid,
  client_key uuid,
  practice_area_key uuid,
  branch_id uuid,
  matter_id uuid,
  duration_min int,
  rounded_min int,
  billable boolean NOT NULL DEFAULT true,
  is_billed boolean NOT NULL DEFAULT false,
  amount numeric(18, 2) NOT NULL DEFAULT 0,
  updated_at timestamptz NOT NULL DEFAULT now()
);
