-- BR-2 (PRD §9): "Limitation/important dates cannot be deleted once within 30
-- days of due — only 'marked satisfied' with note." This blocks DELETE
-- unconditionally once due_at falls within the 30-day window (including
-- already-overdue dates); the only permitted interaction at that point is an
-- UPDATE that sets satisfied_at/satisfied_note. Dates still more than 30 days
-- out remain freely deletable (e.g. cleaning up a mistakenly created reminder).
CREATE OR REPLACE FUNCTION legal.trg_matter_important_dates_block_delete() RETURNS trigger AS $$
BEGIN
  IF OLD.due_at <= now() + interval '30 days' THEN
    RAISE EXCEPTION 'Cannot delete important date % — due % is within 30 days (BR-2). Mark it satisfied instead.', OLD.id, OLD.due_at;
  END IF;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_matter_important_dates_block_delete
  BEFORE DELETE ON legal.matter_important_dates
  FOR EACH ROW
  EXECUTE FUNCTION legal.trg_matter_important_dates_block_delete();
