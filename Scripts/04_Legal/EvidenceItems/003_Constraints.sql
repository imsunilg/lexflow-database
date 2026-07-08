ALTER TABLE legal.evidence_items
  ADD CONSTRAINT ck_evidence_items_kind CHECK (kind IN ('Documentary', 'Electronic', 'Physical'));

ALTER TABLE legal.evidence_items
  ADD CONSTRAINT fk_evidence_items_case FOREIGN KEY (case_id) REFERENCES legal.court_cases (id);

-- Forward-reference FK hoisted here: EvidenceCustodyLog sorts alphabetically
-- before EvidenceItems (Build Playbook §1.1 per-object execution order), so
-- legal.evidence_items doesn't exist yet when EvidenceCustodyLog's own
-- 003_Constraints.sql would otherwise run.
ALTER TABLE legal.evidence_custody_log
  ADD CONSTRAINT fk_evidence_custody_log_evidence FOREIGN KEY (evidence_id) REFERENCES legal.evidence_items (id);

-- document_id is not FK'd yet — see 001_Table.sql comment (dms schema not built).
