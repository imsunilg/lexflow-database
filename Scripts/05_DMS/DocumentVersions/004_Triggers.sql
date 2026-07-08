-- Module 7: document versions are append-only / immutable — "history never
-- rewritten"; only blob_path/size_bytes/hash_sha256/version_no/document_id
-- are immutable once inserted (OCR pipeline fields ocr_status/text_extracted
-- and the audit trio may still be updated as async processing completes).
CREATE OR REPLACE FUNCTION dms.trg_document_versions_block_immutable_update() RETURNS trigger AS $$
BEGIN
  IF NEW.document_id <> OLD.document_id
     OR NEW.version_no <> OLD.version_no
     OR NEW.blob_path <> OLD.blob_path
     OR NEW.size_bytes <> OLD.size_bytes
     OR NEW.hash_sha256 <> OLD.hash_sha256 THEN
    RAISE EXCEPTION 'document_versions is append-only — document_id, version_no, blob_path, size_bytes and hash_sha256 cannot be changed once inserted (version %)', OLD.id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_document_versions_block_immutable_update
  BEFORE UPDATE ON dms.document_versions
  FOR EACH ROW EXECUTE FUNCTION dms.trg_document_versions_block_immutable_update();

CREATE OR REPLACE FUNCTION dms.trg_document_versions_block_delete() RETURNS trigger AS $$
BEGIN
  RAISE EXCEPTION 'document_versions is append-only — DELETE is not permitted (version %)', OLD.id;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_document_versions_block_delete
  BEFORE DELETE ON dms.document_versions
  FOR EACH ROW EXECUTE FUNCTION dms.trg_document_versions_block_delete();

-- Prompt requirement: "documents.current_version_id FK to document_versions
-- with a trigger keeping it in sync". dms.documents does not exist yet at
-- this point (Documents sorts alphabetically after DocumentVersions), but a
-- PL/pgSQL function body is only checked against real objects at first
-- execution, so this is safe to define here — by the time anyone inserts a
-- document version at runtime, dms.documents will exist.
CREATE OR REPLACE FUNCTION dms.trg_document_versions_sync_current() RETURNS trigger AS $$
BEGIN
  UPDATE dms.documents d
  SET current_version_id = NEW.id,
      updated_at = now()
  WHERE d.id = NEW.document_id
    AND (
      d.current_version_id IS NULL
      OR NEW.version_no > (SELECT version_no FROM dms.document_versions WHERE id = d.current_version_id)
    );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_document_versions_sync_current
  AFTER INSERT ON dms.document_versions
  FOR EACH ROW EXECUTE FUNCTION dms.trg_document_versions_sync_current();
