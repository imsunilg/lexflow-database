# 00_Extensions

PostgreSQL extensions required by the schema.

- `001_Enable_Extensions.sql` — enables `pgcrypto` (UUID generation via
  `gen_random_uuid()`, field-level encryption), `pg_trgm` (fuzzy/duplicate
  matching), `ltree` (hierarchical data, e.g. KB act sections), and
  `btree_gist` (GiST exclusion constraints).
