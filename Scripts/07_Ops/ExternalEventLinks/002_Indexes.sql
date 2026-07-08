CREATE INDEX ix_external_event_links_tenant ON ops.external_event_links (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_external_event_links_event ON ops.external_event_links (event_id) WHERE is_deleted = false;

-- Module 6 edge case: "duplicate external event (idempotent by iCalUID)".
CREATE UNIQUE INDEX ux_external_event_links_account_external_id ON ops.external_event_links (external_account_id, external_event_id) WHERE is_deleted = false;
