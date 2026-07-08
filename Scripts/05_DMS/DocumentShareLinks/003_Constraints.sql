ALTER TABLE dms.document_share_links
  ADD CONSTRAINT fk_document_share_links_created_by FOREIGN KEY (created_by) REFERENCES core.users (id);

-- Module 7 validation: "share expiry ≤ 30 days".
ALTER TABLE dms.document_share_links
  ADD CONSTRAINT ck_document_share_links_expiry CHECK (expires_at <= created_at + interval '30 days');

ALTER TABLE dms.document_share_links
  ADD CONSTRAINT ck_document_share_links_max_downloads_nonnegative CHECK (max_downloads IS NULL OR max_downloads > 0);

-- fk_document_share_links_document is added in
-- 05_DMS/Documents/003_Constraints.sql instead — Documents sorts
-- alphabetically after DocumentShareLinks.
