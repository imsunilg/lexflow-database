-- PROMPT DB-8. PRD Module 11 (chat_channels): "channels (firm, team,
-- per-matter auto-channel) + DMs".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- matter_id FK -> legal.matters(id), team_id FK -> core.teams(id) are both
-- backward-safe (04_Legal / 02_Core already built) and added below.
CREATE TABLE comm.chat_channels (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  kind text NOT NULL,
  name text,
  matter_id uuid,
  team_id uuid,
  retention_days int,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
