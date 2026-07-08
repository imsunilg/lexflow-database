CREATE INDEX ix_kb_act_sections_tenant ON kb.kb_act_sections (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_kb_act_sections_parent ON kb.kb_act_sections (parent_id) WHERE is_deleted = false;

-- Module 12 validation rule: "section numbers unique within act".
CREATE UNIQUE INDEX ux_kb_act_sections_act_number ON kb.kb_act_sections (act_id, number) WHERE is_deleted = false;

-- Explicit prompt requirement: ltree path column for fast subtree queries.
CREATE INDEX ix_kb_act_sections_path ON kb.kb_act_sections USING gist (path) WHERE is_deleted = false;
