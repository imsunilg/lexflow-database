-- PROMPT DB-6. PRD Module 8 (tax_configs): "per-firm config: India GST
-- (CGST+SGST vs IGST by place-of-supply, SAC 9982); US: none/state; generic
-- VAT"; "tax config mandatory before first send (else 422
-- TAX_NOT_CONFIGURED)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- branch_id FK -> core.branches(id) is backward-safe (02_Core already
-- built) and added below.
CREATE TABLE fin.tax_configs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  branch_id uuid,
  country_code text NOT NULL,
  tax_type text NOT NULL,
  components jsonb NOT NULL DEFAULT '{}'::jsonb,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
