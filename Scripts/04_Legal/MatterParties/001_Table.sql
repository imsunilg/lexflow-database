-- PROMPT DB-4. PRD §18 (legal.matter_parties), Module 4 Database Tables:
-- "matter_parties(name, party_role[Client|Opposite|Co-party|Witness-org],
-- advocate_name, contact)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- matter_id FK: added in 04_Legal/Matters/003_Constraints.sql, not here —
-- Matters sorts alphabetically after MatterParties (Build Playbook §1.1
-- per-object execution order), so legal.matters doesn't exist yet here.
CREATE TABLE legal.matter_parties (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  matter_id uuid NOT NULL,
  name text NOT NULL,
  party_role text NOT NULL,
  advocate_name text,
  contact jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
