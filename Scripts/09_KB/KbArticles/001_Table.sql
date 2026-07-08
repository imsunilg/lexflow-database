-- PROMPT DB-9. PRD Module 12 (kb_articles(status[Draft|InReview|
-- Published], version)): "Contribute & review: articles support draft →
-- peer review → publish (versioned); judgment headnotes editable with
-- history."
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- author_id / reviewer_id FK -> core.users(id) are backward-safe and added
-- below.
CREATE TABLE kb.kb_articles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  title text NOT NULL,
  body text,
  status text NOT NULL DEFAULT 'Draft',
  version int NOT NULL DEFAULT 1,
  author_id uuid,
  reviewer_id uuid,
  published_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
