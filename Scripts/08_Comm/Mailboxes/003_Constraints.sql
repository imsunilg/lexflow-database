ALTER TABLE comm.mailboxes
  ADD CONSTRAINT ck_mailboxes_provider CHECK (provider IN ('Gmail', 'Microsoft365'));

ALTER TABLE comm.mailboxes
  ADD CONSTRAINT fk_mailboxes_user FOREIGN KEY (user_id) REFERENCES core.users (id);

-- Forward-reference FK hoisted here: EmailThreads sorts alphabetically
-- before Mailboxes (Build Playbook §1.1 per-object execution order), so
-- comm.mailboxes doesn't exist yet when EmailThreads' own
-- 003_Constraints.sql would otherwise run.
ALTER TABLE comm.email_threads
  ADD CONSTRAINT fk_email_threads_mailbox FOREIGN KEY (mailbox_id) REFERENCES comm.mailboxes (id);
