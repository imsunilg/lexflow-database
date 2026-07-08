-- PROMPT DB-3. PRD §18 (crm.client_identity_documents), Module 3 KYC, DPDP rule:
-- "Aadhaar stored only as last-4 + salted hash (full number never persisted)".
-- doc_number_enc is bytea, populated via pgcrypto (pgp_sym_encrypt/encrypt) at
-- the application layer — the plaintext document number is NEVER written to
-- any text/citext column, only this encrypted bytea plus the last4 below.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- client_id FK: added in 03_CRM/Clients/003_Constraints.sql, not here —
-- Clients sorts alphabetically after ClientIdentityDocuments (Build Playbook
-- §1.1 per-object execution order), so crm.clients doesn't exist yet here.
-- document_id: FK to dms.documents(id) deferred — 05_DMS hasn't been built yet
-- (it runs after 03_CRM); the FK will be added when 05_DMS/Documents is built,
-- following the same hoisting pattern used throughout this schema.
CREATE TABLE crm.client_identity_documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  client_id uuid NOT NULL,
  doc_kind text NOT NULL,
  doc_number_enc bytea NOT NULL,
  last4 text NOT NULL,
  expiry_date date,
  document_id uuid,
  verify_status text NOT NULL DEFAULT 'Pending',
  verified_by uuid,
  verified_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
