ALTER TABLE fin.dunning_events
  ADD CONSTRAINT ck_dunning_events_channel CHECK (channel IN ('Email', 'SMS', 'WhatsApp', 'Portal'));

ALTER TABLE fin.dunning_events
  ADD CONSTRAINT ck_dunning_events_status CHECK (status IN ('Pending', 'Sent', 'Failed', 'Skipped'));

-- fk_dunning_events_invoice is added in 06_Fin/Invoices/003_Constraints.sql
-- instead — Invoices sorts alphabetically after DunningEvents.
-- fk_dunning_events_schedule is added in
-- 06_Fin/DunningSchedules/003_Constraints.sql instead — DunningSchedules
-- sorts alphabetically after DunningEvents.
