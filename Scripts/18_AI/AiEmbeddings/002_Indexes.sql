CREATE INDEX ix_ai_embeddings_tenant_source ON ai.ai_embeddings (tenant_id, source_kind, source_id);

CREATE UNIQUE INDEX ux_ai_embeddings_tenant_source_chunk ON ai.ai_embeddings (tenant_id, source_kind, source_id, chunk_index);

-- No ANN (HNSW/ivfflat) index here — those are pgvector-specific and this table's embedding
-- column is a plain double precision[] (see 001_Table.sql). Similarity search scans the
-- tenant+source-filtered candidate set in application code instead of an index-accelerated
-- nearest-neighbour query; acceptable at this system's scale, revisit once pgvector is
-- available on the target Postgres server.
