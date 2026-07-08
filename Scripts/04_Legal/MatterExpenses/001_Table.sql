-- PROMPT DB-4. PRD Module 4 ("expenses logged"). Line-item disbursements
-- incurred on a matter; billing/invoice-line linkage (fin schema) is added
-- once 06_Fin is built.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- matter_id FK: added in 04_Legal/Matters/003_Constraints.sql, not here —
-- Matters sorts alphabetically after MatterExpenses (Build Playbook §1.1
-- per-object execution order), so legal.matters doesn't exist yet here.
-- receipt_document_id: FK to dms.documents(id) deferred — 05_DMS not built yet.
CREATE TABLE legal.matter_expenses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  matter_id uuid NOT NULL,
  incurred_on date NOT NULL DEFAULT current_date,
  category text,
  description text,
  amount numeric(18, 2) NOT NULL,
  billable boolean NOT NULL DEFAULT true,
  receipt_document_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
