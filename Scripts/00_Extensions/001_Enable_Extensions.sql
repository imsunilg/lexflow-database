-- 00_Extensions / 001_Enable_Extensions.sql
--
-- Extensions required across the LexFlow schema. Enabled once, ahead of any
-- schema/table creation, so every later script can rely on them being present.

-- Cryptographic functions, incl. gen_random_uuid() for UUID primary keys and
-- pgp_sym_encrypt/decrypt for field-level encryption of sensitive columns
-- (e.g. crm.client_identity_documents.doc_number). Chosen over uuid-ossp's
-- uuid_generate_v4() so the database has a single, built-in UUID generator.
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Trigram similarity search, used for fuzzy/duplicate matching (lead duplicate
-- detection, conflict-check search over matter/case parties).
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Hierarchical label tree type, used for self-referencing hierarchies with fast
-- subtree queries (e.g. kb.kb_act_sections parent/child structure).
CREATE EXTENSION IF NOT EXISTS ltree;

-- GiST support for btree-indexable types, required for exclusion constraints
-- mixing equality and range checks (e.g. tenant-scoped date/period overlaps).
CREATE EXTENSION IF NOT EXISTS btree_gist;
