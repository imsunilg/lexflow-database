-- PRD §14 (multi-tenant isolation convention) / §20(5). RLS for the three
-- fin.* tables added after 005_Fin_RLS.sql was written (InvoiceStatusHistory,
-- TrustReconciliations, TrustReconciliationItems — Module 8 build-out).

ALTER TABLE fin.invoice_status_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.invoice_status_history FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.invoice_status_history
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.trust_reconciliations ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.trust_reconciliations FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.trust_reconciliations
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE fin.trust_reconciliation_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin.trust_reconciliation_items FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON fin.trust_reconciliation_items
  USING (tenant_id = current_setting('app.tenant_id')::uuid);
