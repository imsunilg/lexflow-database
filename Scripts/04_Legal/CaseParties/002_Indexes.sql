CREATE INDEX ix_case_parties_tenant ON legal.case_parties (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_case_parties_case ON legal.case_parties (case_id) WHERE is_deleted = false;

CREATE INDEX ix_case_parties_advocate_user ON legal.case_parties (advocate_user_id) WHERE is_deleted = false;
