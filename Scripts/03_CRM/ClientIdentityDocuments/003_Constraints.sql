ALTER TABLE crm.client_identity_documents
  ADD CONSTRAINT ck_client_identity_documents_last4_length CHECK (length(last4) = 4);

ALTER TABLE crm.client_identity_documents
  ADD CONSTRAINT ck_client_identity_documents_verify_status CHECK (verify_status IN ('Pending', 'Verified', 'Rejected', 'Expired'));

-- Module 3 validation: "identity doc expiry must be future for 'Verified' status".
ALTER TABLE crm.client_identity_documents
  ADD CONSTRAINT ck_client_identity_documents_verified_expiry CHECK (
    verify_status <> 'Verified' OR expiry_date IS NULL OR expiry_date > verified_at::date
  );

ALTER TABLE crm.client_identity_documents
  ADD CONSTRAINT fk_client_identity_documents_verified_by FOREIGN KEY (verified_by) REFERENCES core.users (id);

-- fk_client_identity_documents_client is added in
-- 03_CRM/Clients/003_Constraints.sql instead of here — Clients sorts
-- alphabetically after ClientIdentityDocuments.
-- document_id is not FK'd yet — see 001_Table.sql comment (dms schema not built).
