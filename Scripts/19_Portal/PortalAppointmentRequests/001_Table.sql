-- Module 17 User Flow #6: "request slot (from lawyer's published availability) -> lawyer
-- confirms/reschedules -> calendar entries both sides + reminders." Validation: "appointment
-- requests >= 24h ahead within published availability" — the >=24h-ahead rule is a
-- request-time check (application layer, since "now" is involved); no DB CHECK for it.
CREATE TABLE portal.portal_appointment_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  client_portal_user_id uuid NOT NULL,
  matter_id uuid NOT NULL,
  lawyer_id uuid NOT NULL,
  requested_start timestamptz NOT NULL,
  requested_end timestamptz NOT NULL,
  notes text,
  status text NOT NULL DEFAULT 'Requested',
  confirmed_start timestamptz,
  confirmed_end timestamptz,
  calendar_event_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid,
  CONSTRAINT fk_portal_appointment_requests_client_portal_user FOREIGN KEY (client_portal_user_id) REFERENCES crm.client_portal_users (id),
  CONSTRAINT fk_portal_appointment_requests_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id),
  CONSTRAINT fk_portal_appointment_requests_lawyer FOREIGN KEY (lawyer_id) REFERENCES core.users (id),
  CONSTRAINT ck_portal_appointment_requests_status CHECK (status IN ('Requested', 'Confirmed', 'Rescheduled', 'Declined', 'Cancelled'))
);
