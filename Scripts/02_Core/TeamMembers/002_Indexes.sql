CREATE INDEX ix_team_members_tenant ON core.team_members (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_team_members_user ON core.team_members (user_id) WHERE is_deleted = false;
