CREATE INDEX ix_portal_appointment_requests_tenant_client ON portal.portal_appointment_requests (tenant_id, client_portal_user_id) WHERE is_deleted = false;
CREATE INDEX ix_portal_appointment_requests_lawyer ON portal.portal_appointment_requests (lawyer_id) WHERE is_deleted = false;
