-- PROMPT DB-2 (Build Playbook §Phase B). PRD §14, §18 (core.* tables), §19.
--
-- Tenants is the one core table WITHOUT a tenant_id column — it IS the tenant,
-- so a self-referencing tenant_id would be meaningless. It also has no
-- created_by/updated_by/deleted_by (no actor can exist before its own tenant
-- does), unlike every other table in this schema.
--
-- Design note on tenant_id and foreign keys throughout 02_Core: DbUp applies
-- scripts in full relative-path order, and per-object folders execute
-- alphabetically (Build Playbook §1.1). Alphabetically, "Tenants" sorts after
-- Branches, Departments, IpAllowlists, LoginHistory, Permissions,
-- RolePermissions, Roles, Sessions, TeamMembers and Teams — so none of those
-- objects' tenant_id columns can carry a physical REFERENCES core.tenants(id)
-- without breaking the apply order. tenant_id therefore stays NOT NULL but
-- unenforced by FK everywhere in this schema; tenant isolation is enforced by
-- the application layer and, from 15_RLS_Policies onward, by Postgres RLS
-- (`current_setting('app.tenant_id')`), not by a hard FK to this table.
CREATE TABLE core.tenants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text NOT NULL,
  status text NOT NULL DEFAULT 'Active',
  plan_tier text NOT NULL DEFAULT 'Standard',
  region text NOT NULL DEFAULT 'india-central',
  default_locale text NOT NULL DEFAULT 'en-IN',
  default_currency text NOT NULL DEFAULT 'INR',
  fiscal_year_start_month smallint NOT NULL DEFAULT 4,
  timezone text NOT NULL DEFAULT 'Asia/Kolkata',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz
);

COMMENT ON TABLE core.tenants IS 'Root tenancy entity (PRD §14/§19). No tenant_id column — this table is the tenant.';
