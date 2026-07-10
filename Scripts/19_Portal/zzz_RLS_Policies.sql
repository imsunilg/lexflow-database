-- PRD §14/§20(5). RLS for the portal schema. Lives inside this folder (rather than
-- 15_RLS_Policies, which executes before 19_Portal in the top-level folder order) for the
-- same reason as 17_Reporting_StarSchema/zzz_RLS_Policies.sql and 18_AI/zzz_RLS_Policies.sql
-- — the "zzz_" prefix sorts this file after every table folder in this directory.

ALTER TABLE portal.portal_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE portal.portal_sessions FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON portal.portal_sessions
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE portal.portal_login_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE portal.portal_login_history FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON portal.portal_login_history
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE portal.portal_message_threads ENABLE ROW LEVEL SECURITY;
ALTER TABLE portal.portal_message_threads FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON portal.portal_message_threads
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE portal.portal_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE portal.portal_messages FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON portal.portal_messages
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE portal.portal_appointment_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE portal.portal_appointment_requests FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON portal.portal_appointment_requests
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE portal.portal_activity_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE portal.portal_activity_log FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON portal.portal_activity_log
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

ALTER TABLE portal.payment_gateway_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE portal.payment_gateway_sessions FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON portal.payment_gateway_sessions
  USING (tenant_id = current_setting('app.tenant_id')::uuid);
