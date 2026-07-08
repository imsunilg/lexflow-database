ALTER TABLE core.tenants
  ADD CONSTRAINT ck_tenants_status CHECK (status IN ('Active', 'Suspended', 'PendingPurge'));

ALTER TABLE core.tenants
  ADD CONSTRAINT ck_tenants_fy_start_month CHECK (fiscal_year_start_month BETWEEN 1 AND 12);
