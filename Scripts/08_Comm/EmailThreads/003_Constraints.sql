ALTER TABLE comm.email_threads
  ADD CONSTRAINT fk_email_threads_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

ALTER TABLE comm.email_threads
  ADD CONSTRAINT fk_email_threads_client FOREIGN KEY (client_id) REFERENCES crm.clients (id);

-- Forward-reference FK hoisted here: EmailMessages sorts alphabetically
-- before EmailThreads (Build Playbook §1.1 per-object execution order), so
-- comm.email_threads doesn't exist yet when EmailMessages' own
-- 003_Constraints.sql would otherwise run.
ALTER TABLE comm.email_messages
  ADD CONSTRAINT fk_email_messages_thread FOREIGN KEY (thread_id) REFERENCES comm.email_threads (id);
