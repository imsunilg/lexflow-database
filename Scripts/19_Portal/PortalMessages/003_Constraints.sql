ALTER TABLE portal.portal_messages ADD CONSTRAINT ck_portal_messages_exactly_one_sender
  CHECK ((sender_client_portal_user_id IS NOT NULL) <> (sender_staff_user_id IS NOT NULL));

ALTER TABLE portal.portal_messages ADD CONSTRAINT ck_portal_messages_body_length
  CHECK (char_length(body) <= 10000);
