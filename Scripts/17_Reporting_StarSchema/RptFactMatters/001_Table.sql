-- PROMPT DB-15. PRD Module 13 Database: "heavy aggregates from
-- nightly-built star-schema tables ..., rpt_fact_matters (refreshed hourly
-- incremental)"; standard report #3 Cases/Matters: "open/closed trends,
-- cycle time by practice area, outcomes (won/lost/settled) by lawyer/
-- court/judge, stage duration analysis, matters per lawyer."
--
-- POPULATION OWNERSHIP: populated and kept current by an hourly
-- incremental job in LexFlow.Workers (a later API-phase prompt) — no
-- backfill/ETL script for it exists here.
--
-- Grain: one row per legal.matters row, upserted on every relevant change
-- (status/outcome/close) rather than append-only — this is a current-state
-- snapshot fact (cycle_time_days is only meaningful once closed_date_key is
-- set), not an event log. No FK anywhere, see
-- rpt.rpt_dim_client/001_Table.sql for why this schema skips them
-- throughout.
CREATE TABLE rpt.rpt_fact_matters (
  fact_matter_key uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  matter_id uuid NOT NULL,
  opened_date_key int,
  closed_date_key int,
  lawyer_key uuid,
  client_key uuid,
  practice_area_key uuid,
  branch_id uuid,
  status text,
  outcome text,
  cycle_time_days int,
  is_open boolean NOT NULL DEFAULT true,
  updated_at timestamptz NOT NULL DEFAULT now()
);
