ALTER TABLE crm.lead_stage_history
  ADD CONSTRAINT fk_lead_stage_history_by_user FOREIGN KEY (by_user) REFERENCES core.users (id);

-- fk_lead_stage_history_lead is added in 03_CRM/Leads/003_Constraints.sql
-- instead of here — Leads sorts alphabetically after LeadStageHistory.
