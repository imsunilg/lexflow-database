-- PROMPT DB-16. PRD Module 16 (AI Features) Architecture: "AI Gateway service (LexFlow.AI)
-- wraps LLM providers ... RAG: tenant-scoped vector store (pgvector) ... Every AI action
-- logged (ai_interactions) ... per-tenant monthly AI-credit quota."
--
-- pgvector (the "vector" extension) is this design's intended embedding column type for
-- ai.ai_embeddings, but it is not installed on this environment's Postgres server (CREATE
-- EXTENSION vector fails with "extension is not available" — it requires the pgvector
-- extension binary to be present on the DB host, which this sandbox doesn't have). Rather than
-- block the whole migration on server-side software this repo doesn't control,
-- ai.ai_embeddings/001_Table.sql stores the embedding as a plain double precision[] array
-- instead, and RagRetrievalService computes cosine similarity in application code. Swapping to
-- a true pgvector column + ANN index later is a column-type + index migration only — the
-- ai_embeddings table shape (tenant_id, source_kind, source_id, chunk_index, chunk_text,
-- metadata) is unaffected. Tenant isolation is the same tenant_id-column + RLS pattern used by
-- every other table in this repo, not a pgvector-specific namespace feature either way.
CREATE SCHEMA IF NOT EXISTS ai;
COMMENT ON SCHEMA ai IS 'AI Gateway: interaction audit log, RAG vector store, per-tenant credit quotas, async transcription jobs (Module 16).';
