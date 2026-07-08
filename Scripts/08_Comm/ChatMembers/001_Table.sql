-- PROMPT DB-8. PRD Module 11 (chat_members): membership roster for
-- comm.chat_channels.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- channel_id FK -> comm.chat_channels(id), user_id FK -> core.users(id) are
-- both backward-safe (ChatChannels / 02_Core already built) and added
-- below.
CREATE TABLE comm.chat_members (
  tenant_id uuid NOT NULL,
  channel_id uuid NOT NULL,
  user_id uuid NOT NULL,
  role text NOT NULL DEFAULT 'member',
  joined_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid,
  PRIMARY KEY (channel_id, user_id)
);
