-- PRD §20(3)/Module 17: portal refresh-token rotation with family-based reuse detection —
-- identical shape/purpose to core.user_sessions, kept as a fully separate table (not a
-- shared table with a discriminator column) per Module 17 Security: "complete identity
-- separation from staff." client_portal_user_id FK added in
-- ../../03_CRM/ClientPortalUsers/003_Constraints.sql is not possible (03_CRM sorts before
-- 19_Portal, so the referenced table already exists) — the FK is added directly below instead
-- since there is no forward-reference ordering problem here.
CREATE TABLE portal.portal_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  client_portal_user_id uuid NOT NULL,
  refresh_hash text NOT NULL,
  family_id uuid NOT NULL,
  ua text,
  ip inet,
  expires_at timestamptz NOT NULL,
  revoked_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid,
  CONSTRAINT fk_portal_sessions_client_portal_user FOREIGN KEY (client_portal_user_id) REFERENCES crm.client_portal_users (id)
);
