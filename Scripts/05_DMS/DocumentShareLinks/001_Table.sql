-- PROMPT DB-5. PRD §18 (dms.document_share_links), Module 7 Validation
-- Rules: "share expiry ≤ 30 days"; Security Rules: "Privileged docs cannot
-- get external share links (hard rule)" — enforced in 004_Triggers.sql.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- document_id FK -> dms.documents(id) is forward (Documents sorts
-- alphabetically after DocumentShareLinks) — added in
-- 05_DMS/Documents/003_Constraints.sql instead.
-- created_by FK -> core.users(id) is backward-safe and added below.
CREATE TABLE dms.document_share_links (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  document_id uuid NOT NULL,
  token_hash text NOT NULL,
  expires_at timestamptz NOT NULL,
  password_hash text,
  max_downloads int,
  downloads int NOT NULL DEFAULT 0,
  watermark boolean NOT NULL DEFAULT true,
  created_by uuid,
  revoked_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
