CREATE INDEX ix_signature_signers_tenant ON dms.signature_signers (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_signature_signers_envelope ON dms.signature_signers (envelope_id, order_no) WHERE is_deleted = false;
