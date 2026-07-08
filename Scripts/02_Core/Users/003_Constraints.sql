-- Users' own constraints.
ALTER TABLE core.users
  ADD CONSTRAINT ck_users_status CHECK (status IN ('Invited', 'Active', 'Suspended', 'Deactivated'));

ALTER TABLE core.users
  ADD CONSTRAINT fk_users_branch FOREIGN KEY (branch_id) REFERENCES core.branches (id);

ALTER TABLE core.users
  ADD CONSTRAINT fk_users_department FOREIGN KEY (department_id) REFERENCES core.departments (id);

-- Forward-reference FKs hoisted here from other 02_Core objects: DbUp applies
-- scripts in full relative-path order, and per-object folders execute
-- alphabetically (Build Playbook §1.1). "Users" sorts alphabetically LAST
-- among 02_Core objects, so every other object that has a genuine domain
-- relationship to core.users (as opposed to a soft audit-actor reference —
-- see the note below) must have that FK added here instead of in its own
-- 003_Constraints.sql, where core.users would not exist yet.
ALTER TABLE core.departments
  ADD CONSTRAINT fk_departments_head_user FOREIGN KEY (head_user_id) REFERENCES core.users (id);

ALTER TABLE core.login_history
  ADD CONSTRAINT fk_login_history_user FOREIGN KEY (user_id) REFERENCES core.users (id);

ALTER TABLE core.user_sessions
  ADD CONSTRAINT fk_user_sessions_user FOREIGN KEY (user_id) REFERENCES core.users (id);

ALTER TABLE core.team_members
  ADD CONSTRAINT fk_team_members_user FOREIGN KEY (user_id) REFERENCES core.users (id);

ALTER TABLE core.teams
  ADD CONSTRAINT fk_teams_lead_user FOREIGN KEY (lead_user_id) REFERENCES core.users (id);

ALTER TABLE core.user_permission_grants
  ADD CONSTRAINT fk_upg_user FOREIGN KEY (user_id) REFERENCES core.users (id);

ALTER TABLE core.user_roles
  ADD CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES core.users (id);

-- Deliberately NOT foreign-keyed anywhere in 02_Core: created_by, updated_by,
-- deleted_by, and user_permission_grants.granted_by. These are soft
-- audit-actor references, not domain relationships — history must remain
-- readable even if the acting user is later hard-deleted (it isn't, given
-- soft-delete, but the principle holds), and 'system'/service actors have no
-- user row at all. Real actor identity for audit purposes lives in
-- audit.audit_events (10_Audit), which references actors logically
-- (entity_type/entity_id), not via FK either (PRD §19 point 15).
