CREATE INDEX ix_teams_tenant ON core.teams (tenant_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_teams_tenant_name ON core.teams (tenant_id, name) WHERE is_deleted = false;

CREATE INDEX ix_teams_lead_user ON core.teams (lead_user_id) WHERE is_deleted = false;
