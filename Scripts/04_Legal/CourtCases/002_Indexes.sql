CREATE INDEX ix_court_cases_tenant ON legal.court_cases (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_court_cases_matter ON legal.court_cases (matter_id) WHERE is_deleted = false;

CREATE INDEX ix_court_cases_court ON legal.court_cases (court_id) WHERE is_deleted = false;

CREATE INDEX ix_court_cases_judge ON legal.court_cases (judge_id) WHERE is_deleted = false;

CREATE INDEX ix_court_cases_appeal_of ON legal.court_cases (appeal_of_case_id) WHERE is_deleted = false;

-- Explicit prompt requirement.
CREATE UNIQUE INDEX ux_court_cases_tenant_court_type_number_year
  ON legal.court_cases (tenant_id, court_id, case_type, case_number, case_year)
  WHERE is_deleted = false;
