CREATE INDEX ix_kb_articles_tenant ON kb.kb_articles (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_kb_articles_status ON kb.kb_articles (tenant_id, status) WHERE is_deleted = false;
