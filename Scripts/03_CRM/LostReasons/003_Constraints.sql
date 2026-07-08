-- Forward-reference FK hoisted here: Leads sorts alphabetically before
-- LostReasons (Build Playbook §1.1 per-object execution order), so
-- crm.lost_reasons doesn't exist yet when Leads' own 003_Constraints.sql would
-- otherwise run. Same pattern used throughout 02_Core — see
-- 02_Core/Users/003_Constraints.sql for the fullest example.
ALTER TABLE crm.leads
  ADD CONSTRAINT fk_leads_lost_reason FOREIGN KEY (lost_reason_id) REFERENCES crm.lost_reasons (id);
