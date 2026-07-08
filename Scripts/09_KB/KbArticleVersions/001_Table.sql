-- PROMPT DB-9. PRD Module 12 (kb_article_versions): "articles support
-- draft → peer review → publish (versioned)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- article_id FK -> kb.kb_articles(id) is forward (KbArticles sorts
-- alphabetically after KbArticleVersions) — added in
-- 09_KB/KbArticles/003_Constraints.sql instead.
-- author_id FK -> core.users(id) is backward-safe and added below.
CREATE TABLE kb.kb_article_versions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  article_id uuid NOT NULL,
  version_no int NOT NULL,
  title text,
  body text,
  author_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
