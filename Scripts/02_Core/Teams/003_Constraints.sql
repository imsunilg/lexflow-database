-- Forward-reference FK hoisted here: TeamMembers sorts alphabetically before
-- Teams (Build Playbook §1.1 per-object execution order), so core.teams
-- doesn't exist yet when TeamMembers' own 003_Constraints.sql would otherwise run.
ALTER TABLE core.team_members
  ADD CONSTRAINT fk_team_members_team FOREIGN KEY (team_id) REFERENCES core.teams (id);
