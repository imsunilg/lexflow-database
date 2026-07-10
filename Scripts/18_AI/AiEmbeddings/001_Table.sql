-- PRD Module 16 Architecture: "RAG: tenant-scoped vector store (pgvector) over documents
-- (OCR text), matters, KB; retrieval always filtered by caller's RBAC scope before context
-- assembly." One row per chunk of source text; source_kind/source_id is a polymorphic
-- reference (Document/Matter/KbJudgment/KbArticle/KbActSection — mirrors kb.kb_item_tags'
-- polymorphic kb_ref_kind/kb_ref_id pattern), resolved and re-authorized against the source
-- record's own read-access rule at retrieval time, not trusted from this table alone (PRD
-- Security: "RBAC-filtered retrieval (test-enforced)").
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- No FK on source_id: it can reference rows in five different schemas/tables.
--
-- embedding is double precision[] rather than a pgvector "vector" column — see this folder's
-- 000_Schema.sql for why (pgvector isn't installed on this environment's Postgres server).
-- RagRetrievalService computes cosine similarity over this array in application code.
CREATE TABLE ai.ai_embeddings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  source_kind text NOT NULL,
  source_id uuid NOT NULL,
  chunk_index int NOT NULL DEFAULT 0,
  chunk_text text NOT NULL,
  embedding double precision[],
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz
);
