ALTER TABLE core.login_history
  ADD CONSTRAINT ck_login_history_result CHECK (result IN ('Success', 'Failed', 'Locked'));

-- fk_login_history_user is added in 02_Core/Users/003_Constraints.sql instead
-- of here — Users sorts alphabetically after LoginHistory (Build Playbook §1.1
-- per-object execution order), so core.users doesn't exist yet at this point.
