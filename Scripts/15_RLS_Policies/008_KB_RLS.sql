-- PROMPT DB-11 (15_RLS_Policies). PRD §14 (multi-tenant isolation
-- convention) / §20(5): "Tenant isolation: JWT tenant claim -> EF
-- global filter + PG RLS + per-tenant blob containers + per-tenant ES
-- filter + per-tenant vector namespace."
--
-- Every tenant-scoped table built in 09_KB (table list scanned live
-- from information_schema/pg_catalog: every base/partitioned table in
-- this schema carrying a tenant_id column, excluding partition-child
-- tables since RLS on a partitioned parent automatically propagates to
-- all its partitions — unlike GRANT/REVOKE, which does not, see
-- 10_Audit/AuditEvents/004_Functions.sql).
--
-- FORCE ROW LEVEL SECURITY makes the policy apply even to the table
-- owner (by default an owner bypasses RLS). NOTE: a superuser always
-- bypasses RLS regardless of FORCE — these migrations run as the
-- postgres superuser, so FORCE has no effect on that connection. It
-- takes effect once the API's runtime role (lexflow_app, created in
-- 10_Audit/AuditEvents/003_Insert_Only_Trigger.sql) owns or is granted
-- rights on these tables and is NOT a superuser, per the explicit
-- prompt requirement.
--
-- app.tenant_id is expected to be set per-connection/transaction by the
-- API (e.g. SET LOCAL app.tenant_id = '<uuid>' inside each request's
-- transaction, sourced from the validated JWT tenant claim).

ALTER TABLE kb.kb_act_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE kb.kb_act_sections FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON kb.kb_act_sections
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE kb.kb_acts ENABLE ROW LEVEL SECURITY;
ALTER TABLE kb.kb_acts FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON kb.kb_acts
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE kb.kb_article_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE kb.kb_article_versions FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON kb.kb_article_versions
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE kb.kb_articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE kb.kb_articles FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON kb.kb_articles
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE kb.kb_bookmarks ENABLE ROW LEVEL SECURITY;
ALTER TABLE kb.kb_bookmarks FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON kb.kb_bookmarks
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE kb.kb_collection_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE kb.kb_collection_items FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON kb.kb_collection_items
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE kb.kb_collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE kb.kb_collections FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON kb.kb_collections
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE kb.kb_item_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE kb.kb_item_tags FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON kb.kb_item_tags
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE kb.kb_judgments ENABLE ROW LEVEL SECURITY;
ALTER TABLE kb.kb_judgments FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON kb.kb_judgments
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE kb.kb_matter_pins ENABLE ROW LEVEL SECURITY;
ALTER TABLE kb.kb_matter_pins FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON kb.kb_matter_pins
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE kb.kb_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE kb.kb_tags FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON kb.kb_tags
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

