# 01_Schemas

CREATE SCHEMA statements defining the schema namespaces used across the database.

- `001_Create_Schemas.sql` — creates `core`, `crm`, `legal`, `dms`, `fin`, `comm`,
  `kb`, `ops`, `audit`, each with a `COMMENT ON SCHEMA` describing its domain.
  No tables yet — those are created per-object in `02_Core` through `10_Audit`.
