-- PROMPT DB-15. PRD Module 13 Database: "rpt_dim_date/lawyer/client/
-- practice_area (refreshed hourly incremental)".
--
-- POPULATION OWNERSHIP: this table's rows are generated and maintained by
-- LexFlow.Workers (a later API-phase prompt) — this migration defines the
-- shape only, no calendar rows are inserted here even though a date range
-- is fully computable in SQL; population is explicitly out of scope for
-- this prompt.
--
-- The one dimension in this schema WITHOUT a tenant_id: a calendar date
-- has no natural tenant ownership (unlike rpt_dim_lawyer/client/
-- practice_area, which mirror tenant-owned source rows) — every tenant's
-- facts join the same shared rows. Tenant-specific fiscal-year framing
-- (firms can configure fiscal_year_start_month, see core.tenants) is
-- deliberately NOT baked into this shared dimension; the job/report layer
-- derives fiscal year/quarter per-tenant at query or ETL time instead.
--
-- date_key is the standard star-schema integer surrogate (YYYYMMDD) for
-- fast join/partition-pruning-style performance versus joining on `date`.
CREATE TABLE rpt.rpt_dim_date (
  date_key int PRIMARY KEY,
  full_date date NOT NULL,
  year int NOT NULL,
  quarter int NOT NULL,
  month int NOT NULL,
  month_name text NOT NULL,
  day int NOT NULL,
  day_of_week int NOT NULL,
  day_name text NOT NULL,
  is_weekend boolean NOT NULL,
  iso_week int NOT NULL
);
