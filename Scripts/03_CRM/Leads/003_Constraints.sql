-- Leads' own constraints.
ALTER TABLE crm.leads
  ADD CONSTRAINT ck_leads_status CHECK (status IN ('Open', 'Converted', 'Lost'));

-- Module 2 validation: "At least one of phone/email required".
ALTER TABLE crm.leads
  ADD CONSTRAINT ck_leads_phone_or_email CHECK (phone_e164 IS NOT NULL OR email IS NOT NULL);

ALTER TABLE crm.leads
  ADD CONSTRAINT fk_leads_source FOREIGN KEY (source_id) REFERENCES crm.lead_sources (id);

ALTER TABLE crm.leads
  ADD CONSTRAINT fk_leads_owner FOREIGN KEY (owner_id) REFERENCES core.users (id);

ALTER TABLE crm.leads
  ADD CONSTRAINT fk_leads_branch FOREIGN KEY (branch_id) REFERENCES core.branches (id);

ALTER TABLE crm.leads
  ADD CONSTRAINT fk_leads_converted_client FOREIGN KEY (converted_client_id) REFERENCES crm.clients (id);

-- Forward-reference FKs hoisted here from other 03_CRM objects — LeadActivities,
-- LeadStageHistory and Clients all sort alphabetically before Leads (Build
-- Playbook §1.1 per-object execution order), so their FKs to/from crm.leads
-- must be added here instead of in their own 003_Constraints.sql. Same pattern
-- as 02_Core/Users/003_Constraints.sql.
ALTER TABLE crm.lead_activities
  ADD CONSTRAINT fk_lead_activities_lead FOREIGN KEY (lead_id) REFERENCES crm.leads (id);

ALTER TABLE crm.lead_stage_history
  ADD CONSTRAINT fk_lead_stage_history_lead FOREIGN KEY (lead_id) REFERENCES crm.leads (id);

ALTER TABLE crm.clients
  ADD CONSTRAINT fk_clients_source_lead FOREIGN KEY (source_lead_id) REFERENCES crm.leads (id);

-- lost_reason_id FK is added in 03_CRM/LostReasons/003_Constraints.sql instead
-- of here — LostReasons sorts alphabetically after Leads.
-- practice_area_id is not FK'd yet — see 001_Table.sql comment.
