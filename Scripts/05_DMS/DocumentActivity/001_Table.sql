-- PROMPT DB-5. PRD §18 (dms.document_activity), Module 7 Security Rules:
-- "every view/download/print writes document_activity".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- document_id FK -> dms.documents(id) is forward (Documents sorts
-- alphabetically after DocumentActivity per Build Playbook §1.1 per-object
-- execution order) — added in 05_DMS/Documents/003_Constraints.sql instead.
-- user_id FK -> core.users(id) is backward-safe and added below (nullable:
-- portal-client or public share-link access has no staff user).
CREATE TABLE dms.document_activity (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  document_id uuid NOT NULL,
  user_id uuid,
  action text NOT NULL,
  at timestamptz NOT NULL DEFAULT now(),
  ip inet,
  ua text,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
