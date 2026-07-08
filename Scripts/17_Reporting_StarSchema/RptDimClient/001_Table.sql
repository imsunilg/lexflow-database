-- PROMPT DB-15. PRD Module 13 Database: "rpt_dim_date/lawyer/client/
-- practice_area (refreshed hourly incremental)".
--
-- POPULATION OWNERSHIP: this table is populated and kept current by an
-- hourly incremental job in LexFlow.Workers (a later API-phase prompt) —
-- no seed/backfill script for it exists anywhere in this repo. The job
-- upserts by client_key (= crm.clients.id) and never hard-deletes a row,
-- even after the source client is deleted, so historical facts that still
-- reference it keep resolving; is_active reflects current source state.
--
-- Denormalized reporting dimension: no FK to crm.clients (or to anything)
-- by design — star-schema dims/facts intentionally skip physical FKs so
-- the hourly job can upsert facts and dimensions independently without
-- load-order constraints, same reasoning documented for
-- fin.mv_dashboard_revenue's NULL-tolerant grain, just taken further here
-- since this whole schema is a denormalized copy, not a system of record.
CREATE TABLE rpt.rpt_dim_client (
  client_key uuid PRIMARY KEY,
  tenant_id uuid NOT NULL,
  display_name text,
  client_type text,
  branch_id uuid,
  is_active boolean NOT NULL DEFAULT true,
  updated_at timestamptz NOT NULL DEFAULT now()
);
