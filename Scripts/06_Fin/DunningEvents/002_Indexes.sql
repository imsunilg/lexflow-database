CREATE INDEX ix_dunning_events_tenant ON fin.dunning_events (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_dunning_events_invoice ON fin.dunning_events (invoice_id) WHERE is_deleted = false;

CREATE INDEX ix_dunning_events_schedule ON fin.dunning_events (schedule_id) WHERE is_deleted = false;

CREATE INDEX ix_dunning_events_pending ON fin.dunning_events (scheduled_for) WHERE status = 'Pending' AND is_deleted = false;
