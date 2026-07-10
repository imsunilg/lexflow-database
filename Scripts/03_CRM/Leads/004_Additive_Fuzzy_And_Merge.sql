-- Additive, added after 03_CRM/Leads had already been applied (DbUp journals
-- by script name, not content hash).
--
-- 1) pg_trgm fuzzy-match support for POST /leads/check-duplicates (Module 2
--    User Flow step 2: "phone/email exact + fuzzy name"). crm.clients already
--    has a display_name trgm index (a generated column); crm.leads has no
--    single display-name column, so this is an expression index over the
--    concatenated name instead.
CREATE INDEX ix_leads_name_trgm ON crm.leads
  USING gin ((coalesce(first_name, '') || ' ' || coalesce(last_name, '')) gin_trgm_ops)
  WHERE is_deleted = false;

-- 2) Client-merge tombstone redirect (Module 3 User Flow step 7 / AC-C3:
--    "loser tombstoned with redirect"). Added on crm.clients here (not in
--    Clients/ itself) purely for file-ordering convenience — same additive
--    pattern as above.
ALTER TABLE crm.clients ADD COLUMN merged_into_client_id uuid;

ALTER TABLE crm.clients
  ADD CONSTRAINT fk_clients_merged_into FOREIGN KEY (merged_into_client_id) REFERENCES crm.clients (id);

CREATE INDEX ix_clients_merged_into ON crm.clients (merged_into_client_id) WHERE merged_into_client_id IS NOT NULL;
