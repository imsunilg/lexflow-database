-- PROMPT DB-7. PRD Module 6 (external_calendar_accounts): "user connects
-- Google (OAuth2, incremental sync via sync tokens + push channels) or
-- Microsoft 365 (Graph, delta queries + webhooks)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- user_id FK -> core.users(id) is backward-safe (02_Core already built)
-- and added below.
-- Tokens are stored encrypted at rest per Module 6 Security Rules ("OAuth
-- tokens encrypted at rest, Key Vault-wrapped DEK") — app-layer
-- pgp_sym_encrypt, hence bytea columns.
CREATE TABLE ops.external_calendar_accounts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  user_id uuid NOT NULL,
  provider text NOT NULL,
  account_email citext,
  access_token_enc bytea,
  refresh_token_enc bytea,
  sync_token text,
  is_active boolean NOT NULL DEFAULT true,
  connected_at timestamptz NOT NULL DEFAULT now(),
  disconnected_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
