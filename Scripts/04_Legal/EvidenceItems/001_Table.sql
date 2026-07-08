-- PROMPT DB-4. PRD §18 (legal.evidence_items), Module 5 (evidence register).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- case_id FK -> legal.court_cases(id) is backward (CourtCases sorts before
-- EvidenceItems) and is added normally in this object's own 003_Constraints.sql.
-- document_id: FK to dms.documents(id) deferred — 05_DMS hasn't been built
-- yet; the FK will be added when 05_DMS/Documents is built.
CREATE TABLE legal.evidence_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  case_id uuid NOT NULL,
  exhibit_no text,
  kind text NOT NULL,
  description text,
  marked boolean NOT NULL DEFAULT false,
  objected boolean NOT NULL DEFAULT false,
  custody_status text,
  document_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
