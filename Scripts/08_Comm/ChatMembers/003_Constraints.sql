ALTER TABLE comm.chat_members
  ADD CONSTRAINT ck_chat_members_role CHECK (role IN ('member', 'admin'));

ALTER TABLE comm.chat_members
  ADD CONSTRAINT fk_chat_members_channel FOREIGN KEY (channel_id) REFERENCES comm.chat_channels (id);

ALTER TABLE comm.chat_members
  ADD CONSTRAINT fk_chat_members_user FOREIGN KEY (user_id) REFERENCES core.users (id);
