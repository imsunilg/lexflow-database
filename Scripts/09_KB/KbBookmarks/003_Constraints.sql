ALTER TABLE kb.kb_bookmarks
  ADD CONSTRAINT ck_kb_bookmarks_ref_kind CHECK (kb_ref_kind IN ('Act', 'ActSection', 'Judgment', 'Article', 'Template'));

ALTER TABLE kb.kb_bookmarks
  ADD CONSTRAINT fk_kb_bookmarks_user FOREIGN KEY (user_id) REFERENCES core.users (id);
