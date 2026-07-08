CREATE INDEX ix_matter_expenses_tenant ON legal.matter_expenses (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_matter_expenses_matter ON legal.matter_expenses (matter_id) WHERE is_deleted = false;
