-- Mirrors core.login_history — separate table for the separate portal identity realm
-- (Module 17 Security: "5 fails/15 min" lockout is computed off this table, same mechanism
-- as staff login lockout in AuthService).
CREATE TABLE portal.portal_login_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  client_portal_user_id uuid,
  at timestamptz NOT NULL DEFAULT now(),
  ip inet,
  ua text,
  result text NOT NULL,
  failure_reason text,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid,
  CONSTRAINT fk_portal_login_history_client_portal_user FOREIGN KEY (client_portal_user_id) REFERENCES crm.client_portal_users (id)
);
