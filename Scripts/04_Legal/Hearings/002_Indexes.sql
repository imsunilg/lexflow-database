CREATE INDEX ix_hearings_tenant_date ON legal.hearings (tenant_id, date) WHERE is_deleted = false;

CREATE INDEX ix_hearings_case ON legal.hearings (case_id) WHERE is_deleted = false;

CREATE INDEX ix_hearings_assigned_lawyer ON legal.hearings (assigned_lawyer_id) WHERE is_deleted = false;

-- Cause-list lookups (AC-CC2: "Cause-list view for any date renders < 1 s").
CREATE INDEX ix_hearings_date_status ON legal.hearings (date, status) WHERE is_deleted = false;
