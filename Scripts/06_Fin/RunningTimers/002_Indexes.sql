CREATE INDEX ix_running_timers_tenant ON fin.running_timers (tenant_id);

CREATE INDEX ix_running_timers_matter ON fin.running_timers (matter_id);
