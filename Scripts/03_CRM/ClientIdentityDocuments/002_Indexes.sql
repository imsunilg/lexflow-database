CREATE INDEX ix_client_identity_documents_tenant ON crm.client_identity_documents (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_client_identity_documents_client ON crm.client_identity_documents (client_id) WHERE is_deleted = false;

CREATE INDEX ix_client_identity_documents_expiry ON crm.client_identity_documents (expiry_date)
  WHERE is_deleted = false AND verify_status = 'Verified';

CREATE INDEX ix_client_identity_documents_verified_by ON crm.client_identity_documents (verified_by) WHERE is_deleted = false;
