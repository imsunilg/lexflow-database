-- Additive to 07_Ops, added after DB-7 had already been applied (DbUp journals by
-- script name, not content hash). Module 6 UI Components: "ICS export per user
-- (read-only secret URL, revocable)"; Security Rules: "ICS secret 128-bit,
-- regenerable." No dedicated table existed for this in the original DB-7 pass — the
-- PRD's own §18 table list for Module 6 didn't call it out as a first-class table.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- user_id FK -> core.users(id) is backward-safe and added below.
CREATE TABLE ops.calendar_ics_tokens (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  user_id uuid NOT NULL,
  token text NOT NULL,
  revoked_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);

ALTER TABLE ops.calendar_ics_tokens
  ADD CONSTRAINT fk_calendar_ics_tokens_user FOREIGN KEY (user_id) REFERENCES core.users (id);

ALTER TABLE ops.calendar_ics_tokens
  ADD CONSTRAINT uq_calendar_ics_tokens_token UNIQUE (token);

CREATE INDEX ix_calendar_ics_tokens_user ON ops.calendar_ics_tokens (tenant_id, user_id) WHERE is_deleted = false;
