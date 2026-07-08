-- PROMPT DB-8. PRD Module 11 (mailboxes): "connect mailbox (Gmail API /
-- Microsoft Graph OAuth)".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- user_id FK -> core.users(id) is backward-safe and added below.
-- Tokens are stored encrypted at rest per Module 11 Security Rules ("comm
-- content is Confidential class — encrypted at rest").
CREATE TABLE comm.mailboxes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  user_id uuid NOT NULL,
  provider text NOT NULL,
  email_address citext NOT NULL,
  access_token_enc bytea,
  refresh_token_enc bytea,
  sync_state jsonb NOT NULL DEFAULT '{}'::jsonb,
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
