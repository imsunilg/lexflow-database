ALTER TABLE kb.kb_article_versions
  ADD CONSTRAINT fk_kb_article_versions_author FOREIGN KEY (author_id) REFERENCES core.users (id);

-- fk_kb_article_versions_article is added in
-- 09_KB/KbArticles/003_Constraints.sql instead — KbArticles sorts
-- alphabetically after KbArticleVersions.
