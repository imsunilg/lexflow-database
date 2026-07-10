ALTER TABLE fin.trust_reconciliations
  ADD CONSTRAINT ck_trust_reconciliations_status CHECK (status IN ('Draft', 'SignedOff'));

ALTER TABLE fin.trust_reconciliations
  ADD CONSTRAINT ck_trust_reconciliations_signoff_requires_signer CHECK (status <> 'SignedOff' OR (signed_off_by IS NOT NULL AND signed_off_at IS NOT NULL));

ALTER TABLE fin.trust_reconciliations
  ADD CONSTRAINT fk_trust_reconciliations_signed_off_by FOREIGN KEY (signed_off_by) REFERENCES core.users (id);

-- Forward-reference FK hoisted here: TrustReconciliationItems sorts
-- alphabetically before TrustReconciliations (Build Playbook §1.1 per-object
-- execution order), so fin.trust_reconciliations doesn't exist yet when
-- TrustReconciliationItems' own 003_Constraints.sql would otherwise run.
ALTER TABLE fin.trust_reconciliation_items
  ADD CONSTRAINT fk_trust_reconciliation_items_reconciliation FOREIGN KEY (reconciliation_id) REFERENCES fin.trust_reconciliations (id);
