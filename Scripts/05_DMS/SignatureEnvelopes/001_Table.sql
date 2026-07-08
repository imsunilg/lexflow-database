-- PROMPT DB-5. PRD §18 (dms.signature_envelopes(document_id, provider,
-- provider_envelope_id, status, completed_doc_version_id)), Module 7:
-- "send for e-signature (DocuSign / Adobe Sign) ... signed copy auto-filed
-- as new version with certificate attached".
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- document_id FK -> dms.documents(id) and completed_doc_version_id FK ->
-- dms.document_versions(id) are both backward-safe (Documents and
-- DocumentVersions already built) and added below.
CREATE TABLE dms.signature_envelopes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  document_id uuid NOT NULL,
  provider text NOT NULL,
  provider_envelope_id text,
  status text NOT NULL DEFAULT 'Draft',
  completed_doc_version_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
