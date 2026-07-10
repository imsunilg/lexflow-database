-- Module 17 User Flow #7: "secure threaded messaging per matter with firm team (not email)."
-- One thread per matter (kept separate from Module 11's comm.chat_channels, which is a
-- staff-internal channel/DM model with no portal-identity concept — Module 17 Security's
-- "complete identity separation" argues for dedicated portal messaging tables rather than
-- reusing/extending the staff chat schema with a discriminator).
CREATE TABLE portal.portal_message_threads (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  matter_id uuid NOT NULL,
  subject text,
  last_message_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid,
  CONSTRAINT fk_portal_message_threads_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id)
);
