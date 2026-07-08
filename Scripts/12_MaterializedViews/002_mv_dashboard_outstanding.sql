-- PROMPT DB-12. PRD Module 1 (Dashboard) widget "Outstanding Payments:
-- aging buckets 0–30/31–60/61–90/90+; total; top 5 debtors."
--
-- Grain: one row per open (unpaid or partially paid) invoice. Aging
-- buckets and "top 5 debtors" are cheap to derive from this at query time
-- (GROUP BY aging_bucket, or ORDER BY outstanding_amount DESC LIMIT 5 per
-- client) — pre-aggregating further here would make drill-down from the
-- widget to the underlying invoice list (Module 1 user flow: "Outstanding
-- ₹4.2L → Invoices filtered status=Overdue") harder to reconcile exactly,
-- so this MV stops at the invoice grain rather than the bucket grain.
--
-- Lives in fin (billing data owns this widget).
--
-- Refresh cadence: every 5 minutes via a recurring Hangfire job in
-- LexFlow.Workers (not pg_cron) — same schedule as mv_dashboard_revenue.
CREATE MATERIALIZED VIEW fin.mv_dashboard_outstanding AS
SELECT
  i.tenant_id,
  m.branch_id,
  i.client_id,
  i.id AS invoice_id,
  i.number AS invoice_number,
  i.due_date,
  GREATEST(current_date - i.due_date, 0) AS days_overdue,
  CASE
    WHEN i.due_date IS NULL OR current_date <= i.due_date THEN 'Current'
    WHEN current_date - i.due_date <= 30 THEN '0-30'
    WHEN current_date - i.due_date <= 60 THEN '31-60'
    WHEN current_date - i.due_date <= 90 THEN '61-90'
    ELSE '90+'
  END AS aging_bucket,
  (i.grand_total - i.amount_paid) AS outstanding_amount
FROM fin.invoices i
JOIN legal.matters m ON m.id = i.matter_id
WHERE i.is_deleted = false
  AND i.status NOT IN ('Draft', 'Void', 'Paid')
  AND (i.grand_total - i.amount_paid) > 0;

CREATE UNIQUE INDEX ux_mv_dashboard_outstanding_invoice
  ON fin.mv_dashboard_outstanding (invoice_id);

COMMENT ON MATERIALIZED VIEW fin.mv_dashboard_outstanding IS
  'Dashboard Outstanding Payments widget (PRD Module 1). Refreshed every 5 minutes via REFRESH MATERIALIZED VIEW CONCURRENTLY, scheduled by a recurring Hangfire job in LexFlow.Workers (not pg_cron).';
