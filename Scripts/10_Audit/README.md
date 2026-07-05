# 10_Audit

Append-only audit trail (schema: `audit`). AuditEvents is partitioned by range and insert-only — UPDATE/DELETE revoked at the grant level.

Per-object subfolders (each populated in Phase B, following the numbering rule in
LexFlow_Build_Playbook.md §1.1):

- `AuditEvents/`

