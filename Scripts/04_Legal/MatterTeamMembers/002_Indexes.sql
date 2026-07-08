CREATE INDEX ix_matter_team_members_tenant ON legal.matter_team_members (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_matter_team_members_user ON legal.matter_team_members (user_id) WHERE is_deleted = false;
