ALTER TABLE comm.chat_messages
  ADD CONSTRAINT fk_chat_messages_channel FOREIGN KEY (channel_id) REFERENCES comm.chat_channels (id);

ALTER TABLE comm.chat_messages
  ADD CONSTRAINT fk_chat_messages_sender FOREIGN KEY (sender_id) REFERENCES core.users (id);

ALTER TABLE comm.chat_messages
  ADD CONSTRAINT fk_chat_messages_task FOREIGN KEY (task_id) REFERENCES ops.tasks (id);

ALTER TABLE comm.chat_messages
  ADD CONSTRAINT fk_chat_messages_document FOREIGN KEY (document_id) REFERENCES dms.documents (id);
