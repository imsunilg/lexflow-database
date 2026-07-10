-- PRD §18/Module 15 ("gateway_configs(secrets as KeyVault refs only)").
-- Backs Settings sections 4-7 (SMTP, SMS Gateway, WhatsApp API, Payment
-- Gateways): one row per (tenant, provider). config_json holds only
-- non-secret fields (host, port, sender id, from-address, WABA id, ...);
-- secret_key_vault_ref names/points at the Key Vault secret holding the
-- actual credential (API key, auth token, gateway secret) — the secret
-- value itself is never stored in this table or returned by any API
-- (§20 "Secrets: Key Vault only"; Module 15 Security: "secrets write-only,
-- never returned").
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
CREATE TABLE core.gateway_configs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  provider text NOT NULL,
  config_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  secret_key_vault_ref text,
  is_enabled boolean NOT NULL DEFAULT false,
  is_test_mode boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
