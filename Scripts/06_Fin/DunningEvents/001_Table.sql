-- PROMPT DB-6. PRD §18 / Module 8 (dunning_events): "reminder schedule
-- (e.g., due−3, due, +7, +15, +30 days) per firm, per-invoice mute".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- invoice_id FK -> fin.invoices(id) is forward (Invoices sorts
-- alphabetically after DunningEvents) — added in
-- 06_Fin/Invoices/003_Constraints.sql instead.
-- schedule_id FK -> fin.dunning_schedules(id) is forward (DunningSchedules
-- sorts alphabetically after DunningEvents) — added in
-- 06_Fin/DunningSchedules/003_Constraints.sql instead.
CREATE TABLE fin.dunning_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  invoice_id uuid NOT NULL,
  schedule_id uuid,
  step_label text NOT NULL,
  channel text NOT NULL,
  scheduled_for timestamptz NOT NULL,
  sent_at timestamptz,
  status text NOT NULL DEFAULT 'Pending',
  muted boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
