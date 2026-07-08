-- PROMPT DB-9. PRD §18 (kb.kb_judgments(citation, neutral_citation,
-- court_id, decision_date, parties, headnote, document_id,
-- UNIQUE(tenant_id, citation))), Module 12: "Judgments/Case Laws (citation,
-- court, bench, date, parties, headnote, full text PDF, tags)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- court_id FK -> legal.courts(id) is backward-safe (04_Legal already built)
-- and added below.
-- document_id FK -> dms.documents(id) is backward-safe — 09_KB runs
-- entirely after 05_DMS in the top-level numeric folder order.
CREATE TABLE kb.kb_judgments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  citation text NOT NULL,
  neutral_citation text,
  court_id uuid,
  decision_date date,
  parties text,
  headnote text,
  document_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
