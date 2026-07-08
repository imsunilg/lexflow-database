-- PROMPT DB-15. PRD Module 13 Database: "heavy aggregates from
-- nightly-built star-schema tables rpt_fact_billing, ... (refreshed hourly
-- incremental)"; standard report #1 Revenue: "billed vs collected by
-- month/quarter, by practice area, by lawyer, by client, by branch;
-- realization rate ...; write-offs."
--
-- POPULATION OWNERSHIP: populated and kept current by an hourly
-- incremental job in LexFlow.Workers (a later API-phase prompt) — no
-- backfill/ETL script for it exists here.
--
-- Grain: one row per fin.invoices row (not per invoice_line — the Revenue
-- report's "by lawyer" cut uses the matter's responsible lawyer rather
-- than a per-line timekeeper, which keeps this fact at a stable,
-- easy-to-reconcile invoice grain matching AC-R1's "totals reconcile with
-- module list-view totals" requirement). date_key/lawyer_key/client_key/
-- practice_area_key are denormalized copies resolved from the invoice's
-- matter at ETL time, joinable to the matching rpt_dim_* rows — no FK, see
-- rpt.rpt_dim_client/001_Table.sql for why this schema skips them
-- throughout.
CREATE TABLE rpt.rpt_fact_billing (
  fact_billing_key uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  invoice_id uuid NOT NULL,
  date_key int,
  lawyer_key uuid,
  client_key uuid,
  practice_area_key uuid,
  branch_id uuid,
  billed_amount numeric(18, 2) NOT NULL DEFAULT 0,
  collected_amount numeric(18, 2) NOT NULL DEFAULT 0,
  write_off_amount numeric(18, 2) NOT NULL DEFAULT 0,
  outstanding_amount numeric(18, 2) NOT NULL DEFAULT 0,
  tax_amount numeric(18, 2) NOT NULL DEFAULT 0,
  updated_at timestamptz NOT NULL DEFAULT now()
);
