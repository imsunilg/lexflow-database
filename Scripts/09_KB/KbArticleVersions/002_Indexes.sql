CREATE INDEX ix_kb_article_versions_tenant ON kb.kb_article_versions (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_kb_article_versions_article_version ON kb.kb_article_versions (article_id, version_no) WHERE is_deleted = false;
