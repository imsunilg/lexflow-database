-- PROMPT DB-5. PRD §18 (dms.signature_signers), Module 7: "pick doc +
-- signers + field placement".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- envelope_id FK -> dms.signature_envelopes(id) is backward-safe
-- (SignatureEnvelopes already built) and added below.
CREATE TABLE dms.signature_signers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  envelope_id uuid NOT NULL,
  name text NOT NULL,
  email citext NOT NULL,
  order_no int NOT NULL DEFAULT 1,
  status text NOT NULL DEFAULT 'Pending',
  signed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
