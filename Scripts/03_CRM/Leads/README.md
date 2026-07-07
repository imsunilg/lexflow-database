# Leads

crm.leads — object folder for the `Leads` table(s), part of the CRM schema (leads/clients). See PRD §18, Module 2 (Leads) and Module 3 (Clients).

Expected files (per the numbering rule in `LexFlow_Build_Playbook.md` §1.1):

| File | Contents |
|---|---|
| `001_Table.sql` | `CREATE TABLE`, PK, column defaults, `tenant_id`/audit columns per PRD §14 |
| `002_Indexes.sql` | all `CREATE INDEX` statements for this object |
| `003_Constraints.sql` | FKs, `CHECK`, `UNIQUE` constraints |
| `004_Triggers.sql` | object-specific triggers (e.g. `updated_at` touch, immutability guards) |
| `005_Seed.sql` | *(only if this is a lookup/reference table)* static seed rows |

This folder is currently empty — table SQL has not been written yet.
