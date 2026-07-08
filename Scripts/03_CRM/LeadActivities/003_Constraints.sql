ALTER TABLE crm.lead_activities
  ADD CONSTRAINT ck_lead_activities_type CHECK (activity_type IN ('call', 'email', 'meeting', 'note'));

ALTER TABLE crm.lead_activities
  ADD CONSTRAINT ck_lead_activities_direction CHECK (direction IS NULL OR direction IN ('inbound', 'outbound'));

ALTER TABLE crm.lead_activities
  ADD CONSTRAINT fk_lead_activities_logged_by FOREIGN KEY (logged_by) REFERENCES core.users (id);

-- fk_lead_activities_lead is added in 03_CRM/Leads/003_Constraints.sql instead
-- of here — Leads sorts alphabetically after LeadActivities.
