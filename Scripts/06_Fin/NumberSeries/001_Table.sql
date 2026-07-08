-- PROMPT DB-6. PRD Module 8 / BR-14 (number_series): "number series
-- `INV-{BR}-{FY}-{seq}`"; BR-14: "{seq} strictly increasing per series; FY
-- reset for financial docs; matter series never resets".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- branch_id FK -> core.branches(id) is backward-safe (02_Core already
-- built) and added below.
CREATE TABLE fin.number_series (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  branch_id uuid,
  series_key text NOT NULL,
  fiscal_year int NOT NULL,
  format_pattern text NOT NULL DEFAULT '{SERIES}-{BR}-{FY}-{SEQ}',
  next_seq bigint NOT NULL DEFAULT 1,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
