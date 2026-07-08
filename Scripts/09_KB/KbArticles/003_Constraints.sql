-- Explicit prompt requirement: status CHECK IN ('Draft','InReview','Published').
ALTER TABLE kb.kb_articles
  ADD CONSTRAINT ck_kb_articles_status CHECK (status IN ('Draft', 'InReview', 'Published'));

ALTER TABLE kb.kb_articles
  ADD CONSTRAINT fk_kb_articles_author FOREIGN KEY (author_id) REFERENCES core.users (id);

ALTER TABLE kb.kb_articles
  ADD CONSTRAINT fk_kb_articles_reviewer FOREIGN KEY (reviewer_id) REFERENCES core.users (id);

-- Forward-reference FK hoisted here: KbArticleVersions sorts alphabetically
-- before KbArticles (Build Playbook §1.1 per-object execution order), so
-- kb.kb_articles doesn't exist yet when KbArticleVersions' own
-- 003_Constraints.sql would otherwise run.
ALTER TABLE kb.kb_article_versions
  ADD CONSTRAINT fk_kb_article_versions_article FOREIGN KEY (article_id) REFERENCES kb.kb_articles (id);
