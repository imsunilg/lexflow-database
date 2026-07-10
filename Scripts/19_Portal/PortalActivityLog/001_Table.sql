-- Module 17 Security: "audit all views of documents/invoices." Insert-only, same role as
-- audit.audit_events but scoped to the portal identity realm (a portal user id has no
-- meaning in audit.audit_events, which references core.users). No FK on entity_id — logical
-- reference only, same rationale as audit.audit_events (§19.15).
CREATE TABLE portal.portal_activity_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  client_portal_user_id uuid NOT NULL,
  action text NOT NULL,
  entity_type text NOT NULL,
  entity_id uuid,
  ip inet,
  ua text,
  at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT fk_portal_activity_log_client_portal_user FOREIGN KEY (client_portal_user_id) REFERENCES crm.client_portal_users (id)
);
