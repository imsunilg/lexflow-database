-- BR-3 Trust before operating: "Balance ≥ 0 enforced at DB." This CHECK is
-- the belt to the 06_Fin/TrustLedgerEntries/004_Triggers.sql
-- INSUFFICIENT_TRUST_BALANCE suspenders — even if a future code path
-- updated current_balance directly instead of through the trigger, it could
-- not push the account negative.
ALTER TABLE fin.trust_accounts
  ADD CONSTRAINT ck_trust_accounts_balance_nonnegative CHECK (current_balance >= 0);

ALTER TABLE fin.trust_accounts
  ADD CONSTRAINT fk_trust_accounts_client FOREIGN KEY (client_id) REFERENCES crm.clients (id);
