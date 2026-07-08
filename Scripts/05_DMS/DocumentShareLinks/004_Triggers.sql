-- Module 7 Security Rules (hard rule): "Privileged docs cannot get external
-- share links". dms.documents does not exist yet at this point in the
-- migration (Documents sorts after DocumentShareLinks), but a PL/pgSQL
-- function body is only checked against real objects at first execution,
-- so this is safe to define here — by the time anyone inserts a share
-- link at runtime, dms.documents will exist.
CREATE OR REPLACE FUNCTION dms.trg_document_share_links_block_privileged() RETURNS trigger AS $$
DECLARE
  v_confidentiality text;
BEGIN
  SELECT confidentiality INTO v_confidentiality FROM dms.documents WHERE id = NEW.document_id;
  IF v_confidentiality = 'Privileged' THEN
    RAISE EXCEPTION 'Cannot create a share link for document % — Privileged documents cannot get external share links (Module 7 hard rule)', NEW.document_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_document_share_links_block_privileged
  BEFORE INSERT ON dms.document_share_links
  FOR EACH ROW EXECUTE FUNCTION dms.trg_document_share_links_block_privileged();
