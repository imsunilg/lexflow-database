-- Additive to 05_DMS, added after DB-5 had already been applied (DbUp journals by
-- script name, not content hash). This prompt explicitly asks for the outbox
-- pattern for Elasticsearch indexing: "write an outbox row in the same
-- transaction as the document insert, a background dispatcher publishes to
-- Service Bus/queue, an indexer worker consumes and calls ES" — that table
-- wasn't part of the original DB-5 pass (the PRD's own §18 table list predates
-- this specific implementation-pattern requirement).
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- document_id/version_id FK -> dms.documents/dms.document_versions already exist
-- (this is a same-session additive migration, not part of the original
-- alphabetical build sequence), so they're normal direct FKs below.
CREATE TABLE dms.document_index_outbox (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  document_id uuid NOT NULL,
  version_id uuid,
  operation text NOT NULL,
  status text NOT NULL DEFAULT 'Pending',
  attempts int NOT NULL DEFAULT 0,
  last_error text,
  created_at timestamptz NOT NULL DEFAULT now(),
  dispatched_at timestamptz,
  processed_at timestamptz,
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);

ALTER TABLE dms.document_index_outbox
  ADD CONSTRAINT fk_document_index_outbox_document FOREIGN KEY (document_id) REFERENCES dms.documents (id);

ALTER TABLE dms.document_index_outbox
  ADD CONSTRAINT fk_document_index_outbox_version FOREIGN KEY (version_id) REFERENCES dms.document_versions (id);

ALTER TABLE dms.document_index_outbox
  ADD CONSTRAINT ck_document_index_outbox_operation CHECK (operation IN ('Index', 'Delete'));

ALTER TABLE dms.document_index_outbox
  ADD CONSTRAINT ck_document_index_outbox_status CHECK (status IN ('Pending', 'Dispatched', 'Done', 'Failed'));

CREATE INDEX ix_document_index_outbox_tenant ON dms.document_index_outbox (tenant_id) WHERE is_deleted = false;

-- The dispatcher's core query: "give me pending work, oldest first."
CREATE INDEX ix_document_index_outbox_pending ON dms.document_index_outbox (created_at) WHERE status = 'Pending' AND is_deleted = false;
