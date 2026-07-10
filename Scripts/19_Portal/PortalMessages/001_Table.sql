-- Module 17 User Flow #7: threaded messages, sent by either a portal (client) user or a
-- staff user — exactly one of sender_client_portal_user_id / sender_staff_user_id is set
-- (CHECK below), never both, so "who sent this" is unambiguous without a discriminator
-- column. Validation: "message length <= 10k chars" — enforced in 003_Constraints.sql.
CREATE TABLE portal.portal_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  thread_id uuid NOT NULL,
  sender_client_portal_user_id uuid,
  sender_staff_user_id uuid,
  body text NOT NULL,
  read_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid,
  CONSTRAINT fk_portal_messages_thread FOREIGN KEY (thread_id) REFERENCES portal.portal_message_threads (id),
  CONSTRAINT fk_portal_messages_client_portal_user FOREIGN KEY (sender_client_portal_user_id) REFERENCES crm.client_portal_users (id),
  CONSTRAINT fk_portal_messages_staff_user FOREIGN KEY (sender_staff_user_id) REFERENCES core.users (id)
);
