-- PROMPT DB-4. PRD §18 (legal.evidence_custody_log — "append-only trigger"),
-- Module 5 AC-CC5 ("edits append, never overwrite").
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- evidence_id FK: added in 04_Legal/EvidenceItems/003_Constraints.sql, not
-- here — EvidenceItems sorts alphabetically after EvidenceCustodyLog (Build
-- Playbook §1.1 per-object execution order), so legal.evidence_items doesn't
-- exist yet at this point.
-- Full audit-trio columns are kept for schema consistency even though the
-- 004_Triggers.sql in this object blocks UPDATE/DELETE outright — matching
-- the same append-only-but-uniformly-shaped pattern as core.login_history.
CREATE TABLE legal.evidence_custody_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  evidence_id uuid NOT NULL,
  action text NOT NULL,
  holder text,
  at timestamptz NOT NULL DEFAULT now(),
  note text,
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);
