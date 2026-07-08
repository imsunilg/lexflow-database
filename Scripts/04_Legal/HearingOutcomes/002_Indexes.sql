CREATE INDEX ix_hearing_outcomes_tenant ON legal.hearing_outcomes (tenant_id) WHERE is_deleted = false;

-- PRD §18: "hearing_id FK UNIQUE" — one outcome per hearing.
CREATE UNIQUE INDEX ux_hearing_outcomes_hearing ON legal.hearing_outcomes (hearing_id) WHERE is_deleted = false;

CREATE INDEX ix_hearing_outcomes_recorded_by ON legal.hearing_outcomes (recorded_by) WHERE is_deleted = false;
