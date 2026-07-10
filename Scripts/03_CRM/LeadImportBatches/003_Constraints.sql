ALTER TABLE crm.lead_import_batches
  ADD CONSTRAINT ck_lead_import_batches_status CHECK (status IN ('Pending', 'Running', 'Completed', 'Failed'));
