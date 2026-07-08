CREATE INDEX ix_matter_important_dates_tenant ON legal.matter_important_dates (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_matter_important_dates_matter ON legal.matter_important_dates (matter_id) WHERE is_deleted = false;

CREATE INDEX ix_matter_important_dates_due ON legal.matter_important_dates (due_at)
  WHERE is_deleted = false AND satisfied_at IS NULL;
