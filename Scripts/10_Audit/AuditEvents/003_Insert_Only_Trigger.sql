-- §18 / §30: "insert-only role; no UPDATE/DELETE grants" — implemented as
-- two independent layers of defense:
--   1. Grant-level: REVOKE UPDATE/DELETE from PUBLIC and from the app role,
--      so the privilege to mutate a row simply does not exist for anything
--      but a superuser/migration owner — this holds even if the trigger
--      below were ever dropped by mistake.
--   2. Trigger-level: BEFORE UPDATE/DELETE raises unconditionally — this
--      holds even for a role that was mistakenly granted UPDATE/DELETE
--      directly, and for any future partition (row-level triggers on a
--      partitioned table's parent apply to every partition automatically).
--
-- lexflow_app is created NOLOGIN here — no credential is embedded in this
-- migration. Ops/deployment provisions the actual login password via Key
-- Vault-sourced secret (per PRD §20 "Secrets: Key Vault only; no secrets in
-- config/env") when wiring the API's connection string to this role.
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'lexflow_app') THEN
    CREATE ROLE lexflow_app NOLOGIN;
  END IF;
END
$$;

GRANT USAGE ON SCHEMA audit TO lexflow_app;
GRANT SELECT, INSERT ON audit.audit_events TO lexflow_app;
REVOKE UPDATE, DELETE ON audit.audit_events FROM lexflow_app;
REVOKE UPDATE, DELETE ON audit.audit_events FROM PUBLIC;

CREATE OR REPLACE FUNCTION audit.trg_audit_events_block_mutation() RETURNS trigger AS $$
BEGIN
  RAISE EXCEPTION 'audit.audit_events is insert-only — % is not permitted (PRD §18 / §30)', TG_OP;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_events_block_update
  BEFORE UPDATE ON audit.audit_events
  FOR EACH ROW EXECUTE FUNCTION audit.trg_audit_events_block_mutation();

CREATE TRIGGER trg_audit_events_block_delete
  BEFORE DELETE ON audit.audit_events
  FOR EACH ROW EXECUTE FUNCTION audit.trg_audit_events_block_mutation();
