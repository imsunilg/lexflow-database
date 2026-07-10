CREATE INDEX ix_lead_import_batches_tenant ON crm.lead_import_batches (tenant_id, created_at DESC) WHERE is_deleted = false;
