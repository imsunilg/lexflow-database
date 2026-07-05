# 12_MaterializedViews

Materialized views for dashboard/report performance (e.g. mv_dashboard_revenue,
mv_dashboard_outstanding, mv_case_stats), each expected to ship with a matching
CREATE UNIQUE INDEX so REFRESH MATERIALIZED VIEW CONCURRENTLY works. Populated in
Phase B (PROMPT DB-12). Empty for now.
