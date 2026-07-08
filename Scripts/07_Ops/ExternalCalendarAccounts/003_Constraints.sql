ALTER TABLE ops.external_calendar_accounts
  ADD CONSTRAINT ck_external_calendar_accounts_provider CHECK (provider IN ('Google', 'Microsoft'));

ALTER TABLE ops.external_calendar_accounts
  ADD CONSTRAINT fk_external_calendar_accounts_user FOREIGN KEY (user_id) REFERENCES core.users (id);
