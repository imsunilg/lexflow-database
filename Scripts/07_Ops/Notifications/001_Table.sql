-- PROMPT DB-7. PRD §18 (ops.notifications(user_id, kind, title, body,
-- deep_link, read_at, channels jsonb)).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- user_id FK -> core.users(id) is backward-safe (02_Core already built)
-- and added below.
CREATE TABLE ops.notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  user_id uuid NOT NULL,
  kind text NOT NULL,
  title text NOT NULL,
  body text,
  deep_link text,
  read_at timestamptz,
  channels jsonb NOT NULL DEFAULT '[]'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
