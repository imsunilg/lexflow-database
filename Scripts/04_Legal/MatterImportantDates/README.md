# MatterImportantDates

SQL scripts for the `MatterImportantDates` object, following the per-object numbering rule
from LexFlow_Build_Playbook.md §1.1:

| File | Contents |
|---|---|
| `001_Table.sql` | `CREATE TABLE`, PK, column defaults, `tenant_id`/audit columns |
| `002_Indexes.sql` | all `CREATE INDEX` statements for this object |
| `003_Constraints.sql` | FKs, `CHECK`, `UNIQUE` constraints |
| `004_Triggers.sql` | object-specific triggers (e.g. `updated_at` touch, immutability guards) |
| `005_Seed.sql` | *(lookup/reference tables only)* static seed rows |

Empty for now — populated during Phase B (Database Build Prompts) of the Build Playbook.
