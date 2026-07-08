CREATE INDEX ix_argument_notes_tenant ON legal.argument_notes (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_argument_notes_case ON legal.argument_notes (case_id) WHERE is_deleted = false;

CREATE INDEX ix_argument_notes_hearing ON legal.argument_notes (hearing_id) WHERE is_deleted = false;
