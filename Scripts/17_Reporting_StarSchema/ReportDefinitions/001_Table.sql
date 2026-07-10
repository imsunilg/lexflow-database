-- PRD Module 13 Database: "custom report definitions in
-- report_definitions(json), report_schedules, report_runs." Custom Report
-- Builder: "Pick base entity ... choose columns (whitelisted field catalog
-- ...) -> filters (AND/OR groups) -> group-by + aggregates -> sort ->
-- preview -> save (private/team/firm) -> schedule."
--
-- definition_json holds the whole builder spec (columns/filters/groupBy/
-- aggregates/sort) validated server-side against the whitelisted field
-- catalog on every read/run — this table stores the user's intent only,
-- never raw SQL (Module 13 Validation: "custom builder field whitelist
-- only (no raw SQL ever)").
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- created_by FK -> core.users(id) is backward-safe and added below.
CREATE TABLE rpt.report_definitions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  name text NOT NULL,
  base_entity text NOT NULL,
  definition_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  visibility text NOT NULL DEFAULT 'private',
  owner_id uuid NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
