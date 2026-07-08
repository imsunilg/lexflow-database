# 12_MaterializedViews

Materialized views backing dashboard widgets (mv_dashboard_revenue, mv_dashboard_outstanding, mv_case_stats, etc.), refreshed on a schedule by LexFlow.Workers. Populated in a later Build Playbook prompt (DB-12).

Built (DB-12): fin.mv_dashboard_revenue, fin.mv_dashboard_outstanding, legal.mv_case_stats — each with a UNIQUE index for CONCURRENTLY refresh, refreshed every 5 min via Hangfire (not pg_cron).
