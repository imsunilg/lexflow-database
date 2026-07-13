# Compatibility

This repo's version lives in `VERSION` at the repo root. None of the three
repos (`lexflow-database`, `lexflow-api`, `lexflow-web`) has ever been
tagged or released — there is no prior version history to reconstruct, so
the matrix below starts from a declared baseline (`0.1.0` in all three)
as of the commits current when this file was introduced, not a
retroactive reconstruction of "what actually shipped when."

## What "DB schema version" means here

There are no EF Core migrations and no down-migrations — schema is raw SQL
scripts under `Scripts/`, applied forward-only by the DbUp-based Runner,
journaled in `public.dbup_schema_versions` (one row per applied script,
never rolled back). "Version" is therefore not a migration count; it's the
semver in `VERSION`, bumped by whoever adds scripts, using this rule:

- **MAJOR** — a destructive or shape-breaking change: a column
  removed/renamed, a type narrowed, a constraint tightened in a way that
  can reject previously-valid data, an RLS policy or trigger changed in a
  way that changes existing query results. Per PRD §14 ("destructive
  changes via expand-contract"), a MAJOR bump should be rare — expand
  first (additive script, deploy, backfill), contract later (a separate,
  later MAJOR bump) rather than doing both in one script.
- **MINOR** — additive: new schema/table/column/index/seed data, nothing
  existing changes shape.
- **PATCH** — a fix to an existing script's logic (e.g. a wrong default,
  a missing index) that doesn't change the resulting shape other schemas
  already depend on.

## Pairing rule with lexflow-api

`LexFlow.Infrastructure`'s `LexFlowDbContext` is Database-First (Fluent API
configurations only, per `lexflow-api/README.md` — "Never run `dotnet ef
migrations add`"), so the API's expectations of column/table shape are
implicit in its Fluent configurations, not generated from this repo.
Concretely:

- API `vN` requires DB schema `>= vN`'s minimum-compatible version — any
  DB version at or above that satisfies it, because MINOR/PATCH bumps are
  additive and don't remove anything the API's Fluent config reads.
- A DB **MAJOR** bump (something removed/renamed/retyped) requires a
  coordinated API MAJOR bump landing in the same deploy — the API's Fluent
  configurations for the changed table(s) must be updated in lockstep, or
  every query touching that table starts failing at runtime (this schema
  has no compile-time check against the API's expectations the way a
  generated ORM migration would).

## Current baseline

| lexflow-database | lexflow-api | lexflow-web | Notes |
|---|---|---|---|
| 0.1.0 | 0.1.0 | 0.1.0 | Declared baseline — see note above; not a tagged release. |

Append a row here whenever any repo's MAJOR or MINOR version changes in a
way that affects what the other two repos require.
