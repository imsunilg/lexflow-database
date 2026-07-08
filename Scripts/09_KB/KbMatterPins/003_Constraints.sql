ALTER TABLE kb.kb_matter_pins
  ADD CONSTRAINT ck_kb_matter_pins_ref_kind CHECK (kb_ref_kind IN ('Act', 'ActSection', 'Judgment', 'Article', 'Template'));

ALTER TABLE kb.kb_matter_pins
  ADD CONSTRAINT fk_kb_matter_pins_matter FOREIGN KEY (matter_id) REFERENCES legal.matters (id);

ALTER TABLE kb.kb_matter_pins
  ADD CONSTRAINT fk_kb_matter_pins_pinned_by FOREIGN KEY (pinned_by) REFERENCES core.users (id);
