-- PROMPT DB-12. PRD Module 1 (Dashboard) widget "Revenue (Finance/Partner):
-- MTD/QTD/YTD collected vs billed vs target; line chart, comparison to
-- prior period"; Database Tables: "widgets read from materialized views
-- refreshed every 5 min: mv_dashboard_revenue, ...".
--
-- Grain: one row per (tenant, branch, practice area, calendar month).
-- billed_amount = invoiced (non-Draft, non-Void) grand_total by issue_date
-- month; collected_amount = payments actually allocated to invoices by
-- received_on month. The API layer rolls this up into MTD/QTD/YTD and
-- prior-period comparisons — this MV only pre-aggregates the expensive
-- join+group so a dashboard request is a cheap indexed scan.
--
-- Lives in fin (billing data owns this widget's numbers) even though it
-- joins legal.matters for branch/practice-area grouping.
--
-- Refresh cadence: every 5 minutes, scheduled via Hangfire in the API/
-- Workers project (LexFlow.Workers), NOT pg_cron — keeps the scheduling
-- surface in one place (.NET) instead of splitting it between the app and
-- the database, per this project's "keep infra simple" preference.
-- REFRESH MATERIALIZED VIEW CONCURRENTLY fin.mv_dashboard_revenue; requires
-- the UNIQUE index below (CONCURRENTLY needs at least one unique index over
-- columns that can't be NULL... here they can be NULL for
-- branch_id/practice_area_id, which is why the index also needs those
-- columns — Postgres unique indexes already permit this because
-- REFRESH CONCURRENTLY diffs whole rows via the index, and a NULL-only
-- grain still yields at most one row per (tenant, month) since it's a
-- straight GROUP BY with no join that could reintroduce duplicates).
CREATE MATERIALIZED VIEW fin.mv_dashboard_revenue AS
WITH billed AS (
  SELECT
    i.tenant_id,
    m.branch_id,
    m.practice_area_id,
    date_trunc('month', i.issue_date)::date AS period_month,
    SUM(i.grand_total) AS billed_amount
  FROM fin.invoices i
  JOIN legal.matters m ON m.id = i.matter_id
  WHERE i.is_deleted = false
    AND i.status NOT IN ('Draft', 'Void')
    AND i.issue_date IS NOT NULL
  GROUP BY i.tenant_id, m.branch_id, m.practice_area_id, date_trunc('month', i.issue_date)
),
collected AS (
  SELECT
    i.tenant_id,
    m.branch_id,
    m.practice_area_id,
    date_trunc('month', p.received_on)::date AS period_month,
    SUM(pa.amount) AS collected_amount
  FROM fin.payment_allocations pa
  JOIN fin.payments p ON p.id = pa.payment_id
  JOIN fin.invoices i ON i.id = pa.invoice_id
  JOIN legal.matters m ON m.id = i.matter_id
  WHERE pa.is_deleted = false
  GROUP BY i.tenant_id, m.branch_id, m.practice_area_id, date_trunc('month', p.received_on)
)
SELECT
  COALESCE(b.tenant_id, c.tenant_id) AS tenant_id,
  COALESCE(b.branch_id, c.branch_id) AS branch_id,
  COALESCE(b.practice_area_id, c.practice_area_id) AS practice_area_id,
  COALESCE(b.period_month, c.period_month) AS period_month,
  COALESCE(b.billed_amount, 0) AS billed_amount,
  COALESCE(c.collected_amount, 0) AS collected_amount
FROM billed b
FULL OUTER JOIN collected c
  ON b.tenant_id = c.tenant_id
  AND b.branch_id IS NOT DISTINCT FROM c.branch_id
  AND b.practice_area_id IS NOT DISTINCT FROM c.practice_area_id
  AND b.period_month = c.period_month;

CREATE UNIQUE INDEX ux_mv_dashboard_revenue_grain
  ON fin.mv_dashboard_revenue (tenant_id, branch_id, practice_area_id, period_month)
  NULLS NOT DISTINCT;

COMMENT ON MATERIALIZED VIEW fin.mv_dashboard_revenue IS
  'Dashboard Revenue widget (PRD Module 1). Refreshed every 5 minutes via REFRESH MATERIALIZED VIEW CONCURRENTLY, scheduled by a recurring Hangfire job in LexFlow.Workers (not pg_cron).';
