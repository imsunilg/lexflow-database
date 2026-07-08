CREATE INDEX ix_invoices_tenant ON fin.invoices (tenant_id) WHERE is_deleted = false;

-- Explicit critical index from PRD §18: "CREATE INDEX ix_invoices_tenant_status_due ON fin.invoices(tenant_id, status, due_date);".
CREATE INDEX ix_invoices_tenant_status_due ON fin.invoices (tenant_id, status, due_date) WHERE is_deleted = false;

CREATE INDEX ix_invoices_matter ON fin.invoices (matter_id) WHERE is_deleted = false;

CREATE INDEX ix_invoices_client ON fin.invoices (client_id) WHERE is_deleted = false;

-- BR-14 / Module 8: invoice numbers are sequential per series per FY, and
-- voided invoice numbers are never reused, so the (tenant, number) pair must
-- stay unique even across voided invoices — no soft-delete predicate here.
CREATE UNIQUE INDEX ux_invoices_tenant_number ON fin.invoices (tenant_id, number);
