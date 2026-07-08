CREATE INDEX ix_signature_envelopes_tenant ON dms.signature_envelopes (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_signature_envelopes_document ON dms.signature_envelopes (document_id) WHERE is_deleted = false;

CREATE UNIQUE INDEX ux_signature_envelopes_provider_ref ON dms.signature_envelopes (provider, provider_envelope_id) WHERE is_deleted = false AND provider_envelope_id IS NOT NULL;
