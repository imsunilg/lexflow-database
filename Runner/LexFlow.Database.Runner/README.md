# LexFlow.Database.Runner

.NET 9 console app that applies every `.sql` script under `../../Scripts/` to a
PostgreSQL 16 database using [DbUp](https://dbup.readthedocs.io/) (`dbup-postgresql`).

## Connection string

Resolved in this order:

1. `LEXFLOW_DB_CONNECTION` environment variable (highest priority).
2. `ConnectionStrings:LexFlowDatabase` in `appsettings.json`.

```
LEXFLOW_DB_CONNECTION="Host=localhost;Port=5432;Database=lexflow;Username=lexflow;Password=lexflow"
```

## Script discovery & ordering

All `*.sql` files under `Scripts/` are discovered recursively and ordered by
their **full relative path** using ordinal string comparison — e.g.
`00_Extensions/001_Enable_Extensions.sql` before `01_Schemas/001_Create_Schemas.sql`,
and within `02_Core/`, `Branches/...` before `Users/...` (alphabetical folder
order) with `001_Table.sql` before `002_Indexes.sql` inside each object folder.
This matches the numbering rule in `LexFlow_Build_Playbook.md` §1.1.

## Usage

```bash
# from the repo root
dotnet run --project Runner/LexFlow.Database.Runner                 # apply
dotnet run --project Runner/LexFlow.Database.Runner -- --dry-run    # print order only, no DB touched
dotnet run --project Runner/LexFlow.Database.Runner -- --scripts-path path/to/Scripts
```

Applied scripts are tracked in a `dbup_schema_versions` journal table (created
automatically), so re-running the tool is idempotent — already-applied scripts
are skipped.
