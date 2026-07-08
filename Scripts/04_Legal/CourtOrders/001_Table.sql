-- PROMPT DB-4. PRD §18 (legal.court_orders), Module 5.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- case_id FK -> legal.court_cases(id) is backward (CourtCases sorts before
-- CourtOrders) and is added normally in this object's own 003_Constraints.sql.
-- hearing_id FK: added in 04_Legal/Hearings/003_Constraints.sql instead —
-- Hearings sorts alphabetically after CourtOrders, so legal.hearings doesn't
-- exist yet at this point.
-- document_id: FK to dms.documents(id) deferred — 05_DMS hasn't been built
-- yet (it runs after 04_Legal); the FK will be added when 05_DMS/Documents is
-- built, following the same hoisting pattern used throughout this schema.
CREATE TABLE legal.court_orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  case_id uuid NOT NULL,
  hearing_id uuid,
  order_date date NOT NULL,
  gist text,
  compliance_due date,
  document_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
