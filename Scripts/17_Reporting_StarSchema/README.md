# 17_Reporting_StarSchema

Reporting star schema (dimension and fact tables) populated incrementally by LexFlow.Workers. Populated in a later Build Playbook prompt (DB-15).

Built (DB-15): new `rpt` schema with rpt_dim_date/lawyer/client/practice_area and rpt_fact_billing/time/matters. Table+Indexes only, no FKs (denormalized star schema) — population is owned entirely by LexFlow.Workers, not this repo.
