ALTER TABLE legal.matter_team_members
  ADD CONSTRAINT fk_matter_team_members_user FOREIGN KEY (user_id) REFERENCES core.users (id);

-- fk_matter_team_members_matter is added in 04_Legal/Matters/003_Constraints.sql
-- instead of here — Matters sorts alphabetically after MatterTeamMembers.
