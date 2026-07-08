ALTER TABLE dms.signature_signers
  ADD CONSTRAINT ck_signature_signers_status CHECK (status IN ('Pending', 'Sent', 'Viewed', 'Signed', 'Declined'));

ALTER TABLE dms.signature_signers
  ADD CONSTRAINT fk_signature_signers_envelope FOREIGN KEY (envelope_id) REFERENCES dms.signature_envelopes (id);
