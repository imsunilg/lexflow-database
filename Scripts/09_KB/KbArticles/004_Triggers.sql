-- Module 12 validation rule (peer-review rule): "article publish requires
-- ≥1 tag + reviewer ≠ author". This trigger enforces the reviewer ≠ author
-- half at the DB level — a self-review can never be recorded as the
-- publishing reviewer.
CREATE OR REPLACE FUNCTION kb.trg_kb_articles_block_self_review_publish() RETURNS trigger AS $$
BEGIN
  IF NEW.status = 'Published' AND NEW.reviewer_id IS NOT NULL AND NEW.reviewer_id = NEW.author_id THEN
    RAISE EXCEPTION 'Cannot publish article % — reviewer must differ from author (Module 12 peer-review rule)', NEW.id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_kb_articles_block_self_review_publish
  BEFORE INSERT OR UPDATE ON kb.kb_articles
  FOR EACH ROW EXECUTE FUNCTION kb.trg_kb_articles_block_self_review_publish();
