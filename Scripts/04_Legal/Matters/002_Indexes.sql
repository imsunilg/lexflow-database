CREATE INDEX ix_matters_tenant ON legal.matters (tenant_id) WHERE is_deleted = false;

-- Explicit prompt requirement.
CREATE UNIQUE INDEX ux_matters_tenant_number ON legal.matters (tenant_id, number) WHERE is_deleted = false;

CREATE INDEX ix_matters_client ON legal.matters (client_id) WHERE is_deleted = false;

CREATE INDEX ix_matters_tenant_lawyer_status ON legal.matters (tenant_id, responsible_lawyer_id, status) WHERE is_deleted = false;

CREATE INDEX ix_matters_branch ON legal.matters (branch_id) WHERE is_deleted = false;

CREATE INDEX ix_matters_practice_area ON legal.matters (practice_area_id) WHERE is_deleted = false;
