CREATE INDEX ix_call_logs_tenant ON comm.call_logs (tenant_id) WHERE is_deleted = false;

CREATE INDEX ix_call_logs_client ON comm.call_logs (client_id, occurred_at DESC) WHERE is_deleted = false;

CREATE INDEX ix_call_logs_matter ON comm.call_logs (matter_id) WHERE is_deleted = false;
