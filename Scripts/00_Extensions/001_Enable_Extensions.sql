-- PROMPT DB-1 (Build Playbook §Phase B). Extensions required before any schema/table exists.
-- pgcrypto: gen_random_uuid() for all PKs, plus symmetric encryption for KYC/PII columns (PRD §14, §18).
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- citext: case-insensitive text, used for core.users.email (PRD §18 core.users, DB-2).
CREATE EXTENSION IF NOT EXISTS citext;

-- pg_trgm: trigram indexes backing fuzzy/fallback search (PRD §14 full-text, §26 search requirements).
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- ltree: hierarchical paths for dms.folders and kb.kb_act_sections (PRD §18).
CREATE EXTENSION IF NOT EXISTS ltree;

-- btree_gist: required for exclusion constraints combined with equality (e.g. tenant-scoped range checks).
CREATE EXTENSION IF NOT EXISTS btree_gist;
