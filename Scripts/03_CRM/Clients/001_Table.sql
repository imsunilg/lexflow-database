-- PROMPT DB-3. PRD §14, §18 (crm.clients), Module 3.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- pan_enc: pgcrypto-encrypted at the application layer (AES-256-GCM per PRD
-- §20(6)); the DB column is bytea and never holds plaintext.
-- practice-area-style FK is not applicable here; owner_id/branch_id FK to
-- core.users/core.branches are added in 003_Constraints.sql (backward
-- reference — 02_Core already exists by the time 03_CRM runs).
-- source_lead_id: FK to crm.leads(id) is added in Leads/003_Constraints.sql,
-- not here — Leads sorts alphabetically after Clients (Build Playbook §1.1
-- per-object execution order), so crm.leads doesn't exist yet at this point.
CREATE TABLE crm.clients (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  number text NOT NULL,
  type text NOT NULL,
  first_name text,
  last_name text,
  legal_name text,
  display_name text GENERATED ALWAYS AS (
    CASE
      WHEN type = 'Corporate' THEN legal_name
      ELSE nullif(trim(both ' ' from coalesce(first_name, '') || ' ' || coalesce(last_name, '')), '')
    END
  ) STORED,
  email citext,
  phone_e164 text,
  pan_enc bytea,
  gstin text,
  cin text,
  status text NOT NULL DEFAULT 'Active',
  credit_limit numeric(18, 2),
  owner_id uuid,
  branch_id uuid,
  portal_enabled boolean NOT NULL DEFAULT false,
  source_lead_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
