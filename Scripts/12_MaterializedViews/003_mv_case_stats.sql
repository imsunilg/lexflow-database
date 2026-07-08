-- PROMPT DB-12. PRD Module 1 (Dashboard) widget "Case Statistics: open/
-- closed/won/lost/settled counts; by stage funnel."
--
-- Grain: one row per (tenant, branch, practice area, matter status,
-- outcome) with a count — the dashboard widget sums/filters this small
-- pre-aggregated set instead of scanning legal.matters directly. status
-- covers Open/OnHold/Closed/Reopened; outcome (Won/Lost/Settled/Withdrawn)
-- is only ever set once a matter is Closed, so grouping by both together
-- gives "closed, won" vs "closed, lost" vs "still open" in one shape.
--
-- Lives in legal (matters data owns this widget).
--
-- Refresh cadence: every 5 minutes via a recurring Hangfire job in
-- LexFlow.Workers (not pg_cron) — same schedule as the other dashboard MVs.
CREATE MATERIALIZED VIEW legal.mv_case_stats AS
SELECT
  m.tenant_id,
  m.branch_id,
  m.practice_area_id,
  m.status,
  m.outcome,
  count(*) AS matter_count
FROM legal.matters m
WHERE m.is_deleted = false
GROUP BY m.tenant_id, m.branch_id, m.practice_area_id, m.status, m.outcome;

CREATE UNIQUE INDEX ux_mv_case_stats_grain
  ON legal.mv_case_stats (tenant_id, branch_id, practice_area_id, status, outcome)
  NULLS NOT DISTINCT;

COMMENT ON MATERIALIZED VIEW legal.mv_case_stats IS
  'Dashboard Case Statistics widget (PRD Module 1). Refreshed every 5 minutes via REFRESH MATERIALIZED VIEW CONCURRENTLY, scheduled by a recurring Hangfire job in LexFlow.Workers (not pg_cron).';
