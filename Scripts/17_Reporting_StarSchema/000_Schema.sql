-- PROMPT DB-15. PRD Module 13 (Reports & Analytics) Database: "Reporting
-- reads from read-replica; heavy aggregates from nightly-built star-schema
-- tables rpt_fact_billing, rpt_fact_time, rpt_fact_matters,
-- rpt_dim_date/lawyer/client/practice_area (refreshed hourly incremental)."
--
-- No schema named "rpt" is among §14's binding schema-per-concern list
-- (core, crm, legal, dms, fin, comm, kb, ops, audit) because the star
-- schema didn't exist yet when that list was written — it's introduced
-- here as its own schema since a read-optimized reporting layer is a
-- genuinely distinct concern from every OLTP schema it denormalizes.
CREATE SCHEMA IF NOT EXISTS rpt;
COMMENT ON SCHEMA rpt IS 'Reporting star schema (dimension + fact tables) for Module 13 Reports & Analytics. Populated by an hourly incremental job in LexFlow.Workers — not by any script in this repo. See rpt.rpt_dim_date etc. for the population-ownership note repeated on every object.';
