# LexFlow — Build Playbook
## Step-by-Step AI Prompts to Generate the Full Project (Angular + .NET Core + PostgreSQL)

> **Companion document to `LexFlow_PRD.md`.** Every prompt below assumes the AI coding assistant (Claude Code, Cursor, Windsurf, Copilot) has the PRD in context or open in the repo as `/docs/LexFlow_PRD.md`. Paste prompts **one at a time, in order**, into a fresh or continuing session. Each prompt is self-contained: it states its inputs, its outputs, and the folder/numbering rule to follow.

---

## 0. How to Use This Playbook

1. Create three **separate, independent repositories/projects** (not a monorepo) — see §1.
2. Work through **Phase A → E** in order. Within a phase, prompts are sequential; later prompts depend on earlier ones.
3. After every prompt, review the generated output, run it (`dotnet build`, `ng build`, or run the SQL scripts), fix drift, **then** move to the next prompt.
4. Every DB, API, and UI prompt tells the assistant to re-read the relevant PRD section (`§`) before generating code — this keeps 100+ pages of business rules from being forgotten mid-build.
5. **Schema-ownership rule (important amendment to the PRD):** because you asked for a dedicated, numbered SQL database project, **PostgreSQL schema is authored by hand in raw SQL scripts, not by EF Core migrations.** EF Core in the API project is configured *Code-First-to-existing-schema* (Fluent API mappings only, `MigrationsAssembly` disabled). The SQL project is the single source of truth for schema; the API project must never generate or apply an EF migration that alters schema.

---

## 1. Project / Repository Structure

```
lexflow-database/            → PostgreSQL schema, numbered SQL, DbUp runner
lexflow-api/                 → .NET 9 Web API, Clean Architecture
lexflow-web/                 → Angular 20+ workspace (staff app + client portal)
```

(Mobile app — Flutter — is a fourth optional repo, `lexflow-mobile`; prompts for it are in §Phase D, end.)

### 1.1 `lexflow-database` layout
```
lexflow-database/
├── Scripts/
│   ├── 00_Extensions/
│   │   └── 001_Enable_Extensions.sql
│   ├── 01_Schemas/
│   │   └── 001_Create_Schemas.sql
│   ├── 02_Core/
│   │   ├── Tenants/            001_Table.sql  002_Indexes.sql  003_Constraints.sql
│   │   ├── Branches/           001_Table.sql  002_Indexes.sql
│   │   ├── Users/               001_Table.sql  002_Indexes.sql  003_Constraints.sql  004_Triggers.sql
│   │   ├── Roles/  Permissions/  RolePermissions/  UserRoles/  UserPermissionGrants/
│   │   ├── Teams/  TeamMembers/  Departments/
│   │   └── Sessions/  LoginHistory/  IpAllowlists/
│   ├── 03_CRM/
│   │   ├── LeadSources/  Leads/  LeadActivities/  LeadStageHistory/  LostReasons/
│   │   └── Clients/  ClientContacts/  ClientAddresses/  ClientIdentityDocuments/  ClientRelationships/  ClientPortalUsers/
│   ├── 04_Legal/
│   │   ├── PracticeAreas/  Matters/  MatterTeamMembers/  MatterParties/  MatterImportantDates/  MatterRelated/  MatterExpenses/
│   │   └── Courts/  Judges/  CourtCases/  Hearings/  HearingOutcomes/  CourtOrders/  CaseParties/  EvidenceItems/  EvidenceCustodyLog/  Witnesses/  ArgumentNotes/  CourtHolidays/
│   ├── 05_DMS/
│   │   ├── Folders/  Documents/  DocumentVersions/  DocumentTags/  Tags/  DocumentPermissions/  DocumentShareLinks/
│   │   └── DocumentTemplates/  TemplateMergeFields/  SignatureEnvelopes/  SignatureSigners/  DocumentActivity/
│   ├── 06_Fin/
│   │   ├── RateCards/  RateCardEntries/  BillingArrangements/
│   │   ├── Invoices/  InvoiceLines/  InvoiceTaxes/  InvoiceStatusHistory/
│   │   ├── Payments/  PaymentAllocations/  CreditNotes/  Refunds/  DunningSchedules/  DunningEvents/
│   │   ├── TrustAccounts/  TrustLedgerEntries/  TrustReconciliations/  TrustReconciliationItems/
│   │   ├── TaxConfigs/  NumberSeries/
│   │   └── TimeEntries/  RunningTimers/  ActivityCodes/
│   ├── 07_Ops/
│   │   ├── Tasks/  TaskAssignees/  TaskChecklistItems/  TaskComments/  TaskDependencies/  TaskTemplates/  TaskTemplateItems/
│   │   ├── CalendarEvents/  EventAttendees/  EventReminders/  RecurrenceExceptions/  ExternalCalendarAccounts/  ExternalEventLinks/
│   │   ├── WorkflowRules/  WorkflowRuns/
│   │   └── Notifications/  ReminderDispatchLog/
│   ├── 08_Comm/
│   │   ├── Mailboxes/  EmailThreads/  EmailMessages/  EmailAttachments/
│   │   ├── SmsMessages/  WhatsappMessages/  WhatsappOptins/  CallLogs/
│   │   └── ChatChannels/  ChatMembers/  ChatMessages/  CommTemplates/
│   ├── 09_KB/
│   │   ├── KbActs/  KbActSections/  KbJudgments/
│   │   └── KbArticles/  KbArticleVersions/  KbTags/  KbItemTags/  KbCollections/  KbCollectionItems/  KbBookmarks/  KbMatterPins/
│   ├── 10_Audit/
│   │   └── AuditEvents/         001_Table.sql (partitioned)  002_Indexes.sql  003_Insert_Only_Trigger.sql
│   ├── 11_Views/
│   ├── 12_MaterializedViews/
│   ├── 13_Functions/
│   ├── 14_Triggers_Global/
│   ├── 15_RLS_Policies/
│   ├── 16_Seed/
│   └── 17_Reporting_StarSchema/
├── Runner/
│   └── LexFlow.Database.Runner/     (DbUp console app)
└── README.md
```

**Per-object numbering rule (applies to every object folder above):**
| File | Contents |
|---|---|
| `001_Table.sql` | `CREATE TABLE`, PK, column defaults, `tenant_id`/audit columns per PRD §14 |
| `002_Indexes.sql` | all `CREATE INDEX` for that object |
| `003_Constraints.sql` | FKs, `CHECK`, `UNIQUE` constraints |
| `004_Triggers.sql` | object-specific triggers (e.g. `updated_at` touch, immutability guards) |
| `005_Seed.sql` | *(only if the object is a lookup/reference table)* static seed rows |

Top-level folders execute in numeric order (`00_` → `17_`); inside each, per-object folders execute alphabetically, and files inside each object folder execute in numeric order. This total ordering is what the DbUp runner walks.

### 1.2 `lexflow-api` layout
```
lexflow-api/
├── src/
│   ├── LexFlow.Domain/              (entities, value objects, domain events, enums)
│   ├── LexFlow.Application/         (CQRS: Commands/Queries/Handlers, DTOs, validators, interfaces)
│   ├── LexFlow.Infrastructure/      (EF Core DbContext+configs, Postgres, Redis, Elasticsearch, Blob, external providers)
│   ├── LexFlow.Api/                 (Web API host: controllers, middleware, SignalR hubs, Program.cs)
│   └── LexFlow.Workers/             (Hangfire background jobs: OCR, indexing, reminders, dunning)
├── tests/
│   ├── LexFlow.UnitTests/
│   ├── LexFlow.IntegrationTests/    (Testcontainers)
│   └── LexFlow.E2ETests/            (WebApplicationFactory + Playwright API smoke)
├── LexFlow.sln
└── README.md
```

### 1.3 `lexflow-web` layout
```
lexflow-web/
├── projects/
│   ├── staff-portal/                (main Angular app — internal users)
│   ├── client-portal/               (separate Angular app — clients, §Module 17)
│   └── shared/                      (Angular library: design system, models, interceptors, shared services)
├── e2e/                             (Playwright)
├── angular.json
└── README.md
```

---

## PHASE A — Scaffolding (3 prompts)

### PROMPT A-1 — Database project scaffold
```
Read LexFlow_PRD.md §14, §18, §19. Create a new repository "lexflow-database".
Set up the exact folder tree in §1.1 of LexFlow_Build_Playbook.md (all 00_ through
17_ top-level folders; leave per-object subfolders empty for now except for a
README.md in each explaining what belongs there). Create Runner/LexFlow.Database.Runner
as a .NET 9 console app using the DbUp NuGet package (DbUp-Postgresql) that:
 - reads a connection string from appsettings.json / env var LEXFLOW_DB_CONNECTION,
 - discovers all .sql files under Scripts/ recursively,
 - orders them by full relative path (so 00_.../001_...sql runs before 01_.../001_...sql),
 - executes them inside DbUp's transactional journal (tracks applied scripts in a
   dbup_schema_versions table so reruns are idempotent),
 - supports a --dry-run flag that prints the execution order without applying.
Add a GitHub Actions workflow .github/workflows/db-migrate.yml that runs the runner
against a PostgreSQL 16 service container on every PR (schema must apply cleanly
from empty) and against staging on merge to main.
Output: full repo tree + Runner source code + workflow file. Do not write table SQL yet.
```

### PROMPT A-2 — API project scaffold
```
Read LexFlow_PRD.md (technical requirements, §14, §20, §37, §38). Create a new
repository "lexflow-api" as a .NET 9 solution using Clean Architecture with the
exact project layout in §1.2 of LexFlow_Build_Playbook.md.
 - LexFlow.Domain: no external dependencies.
 - LexFlow.Application: MediatR (CQRS), FluentValidation, Mapster (mapping),
   defines repository/service interfaces, no EF/Npgsql references.
 - LexFlow.Infrastructure: EF Core 9 + Npgsql provider configured in
   *Database-First* mode — DbContext with Fluent API configurations only,
   EF migrations DISABLED (no Add-Migration usage anywhere; schema is owned by
   lexflow-database). Add Redis (StackExchange.Redis), Elasticsearch (Elastic.Clients.Elasticsearch),
   Azure.Storage.Blobs, Azure.Security.KeyVault.Secrets client registrations (stubs OK).
 - LexFlow.Api: ASP.NET Core Web API, Swashbuckle/Swagger with OpenAPI 3.1,
   Serilog + OpenTelemetry wired per §29, global exception middleware returning
   the envelope in §17, health checks endpoint, CORS policy for the two Angular
   apps, SignalR hub stubs for /hubs/notifications, /hubs/chat, /hubs/presence, /hubs/jobs.
 - LexFlow.Workers: Hangfire host with Postgres storage, empty job registry.
 - tests/: three empty test projects wired into the solution with xUnit,
   FluentAssertions, Testcontainers.PostgreSql referenced.
Add multi-stage Dockerfile and docker-compose.yml (api + postgres + redis + elasticsearch)
for local dev. Add .github/workflows/api-ci.yml (build, test, SonarQube gate stub, Trivy scan).
Output: full solution tree, csproj files, Program.cs wiring, empty but compiling.
```

### PROMPT A-3 — UI project scaffold
```
Read LexFlow_PRD.md §12, §13, technical requirements. Create a new repository
"lexflow-web" as an Angular 20+ workspace with the exact layout in §1.3 of
LexFlow_Build_Playbook.md:
 - projects/shared: publishable Angular library containing: design tokens
   (CSS custom properties per §12 palette/typography), Tailwind config,
   Angular Material theme (light+dark), core interceptors (auth/JWT refresh,
   error-envelope-to-toast, idempotency-key injector), auth guards, a
   PermissionService (consumes GET /permissions/catalog + /auth/me), base
   models generated placeholder folder (models will be filled per module later),
   a DashboardWidgetComponent shell, and reusable UI components: data-table
   (server-side sort/filter/page/virtualized), empty-state, confirm-dialog,
   file-uploader, date-range-picker, currency-pipe, status-chip.
 - projects/staff-portal: standalone-components app, lazy-loaded route shell
   per §13 nav structure (empty feature folders: dashboard, leads, clients,
   matters, calendar, documents, billing, time, tasks, communication,
   knowledge-base, reports, ai-studio, admin — each just a routed placeholder
   page for now), left icon-rail nav + top bar (search, timer chip stub,
   notifications, quick-add) per §12.
 - projects/client-portal: separate standalone app, its own auth flow pointing
   at /api/portal/v1, route shell per §Module 17 nav (home, matters, invoices,
   documents, appointments, messages, profile — placeholders).
 - PWA config (ngsw) on both apps. i18n scaffolding for en + hi with
   extraction script. ESLint + Prettier + Stylelint configured. Angular
   Material + Tailwind installed and wired together per §12 (no class conflicts).
 - e2e/ Playwright config pointed at both app dev servers.
 - .github/workflows/web-ci.yml (lint, build both apps, unit tests, bundle-size
   budget check per §31, Playwright smoke).
Output: full workspace tree, all configs, both apps building and serving with
placeholder pages navigable via the shell nav.
```

---

## PHASE B — Database Build Prompts (`lexflow-database`)

Each prompt below fills one or more numbered top-level folders. Always instruct: *"Follow the per-object file numbering rule exactly: 001_Table.sql, 002_Indexes.sql, 003_Constraints.sql, 004_Triggers.sql, 005_Seed.sql where applicable."*

### PROMPT DB-1 — Extensions & Schemas
```
Read LexFlow_PRD.md §14. Populate 00_Extensions/001_Enable_Extensions.sql with
pgcrypto, uuid-ossp (or use gen_random_uuid from pgcrypto), pg_trgm, ltree,
btree_gist. Populate 01_Schemas/001_Create_Schemas.sql creating schemas: core,
crm, legal, dms, fin, comm, kb, ops, audit — each with a comment describing its
domain per §14. Do not create any tables yet.
```

### PROMPT DB-2 — Core schema (tenancy, users, RBAC, branches)
```
Read LexFlow_PRD.md §14, §18 (core.* tables), §21 (permissions matrix), §20.
For every object listed under 02_Core/ in the Build Playbook tree, create its
001_Table.sql/002_Indexes.sql/003_Constraints.sql/004_Triggers.sql following
the shared conventions: tenant_id uuid NOT NULL, created_at/created_by/
updated_at/updated_by, is_deleted/deleted_at/deleted_by, UUID PKs via
gen_random_uuid(). Enforce: users.email citext UNIQUE per (tenant_id,email);
role_permissions/user_roles as composite-PK join tables; a partial unique
index ensuring at least one 'Owner' role row per tenant cannot be deleted
(implement as a trigger on user_roles preventing removal of the last Owner —
BR referenced in PRD §Module 14 AC-U3). Add 004_Triggers.sql on users for
auto-updating updated_at. Do not add RLS policies yet (that's 15_RLS_Policies).
```

### PROMPT DB-3 — CRM schema (leads, clients)
```
Read LexFlow_PRD.md §18 (crm.* tables), Module 2 and Module 3 validation
rules/edge cases. Build every object under 03_CRM/ with full
Table/Indexes/Constraints/Triggers files. Implement: leads unique partial
index (tenant_id, phone_e164) WHERE status='Open' (FR duplicate rule);
client_identity_documents storing doc_number as bytea (pgcrypto-encrypted)
+ last4 text, never the plaintext full number (PRD BR/DPDP rule in §Module 3);
client_relationships self-referencing FK with relation_type CHECK constraint
listing the enum values from §18. Add a trigger on clients preventing hard
delete while any legal.matters row references it (defense-in-depth; app also
enforces this).
```

### PROMPT DB-4 — Legal schema (matters, court cases, hearings)
```
Read LexFlow_PRD.md §18 (legal.* tables), Module 4 and Module 5 in full
(business rules, edge cases, BR-1 conflict check, BR-2 limitation dates,
BR-6 hearing chain invariant). Build every object under 04_Legal/. Critically
implement:
 - matters.number UNIQUE(tenant_id, number).
 - court_cases UNIQUE(tenant_id, court_id, case_type, case_number, case_year).
 - a CHECK/trigger enforcing BR-6: a court_case with status NOT IN
   ('Disposed','Transferred') must have at least one hearing with
   status='Scheduled' and date >= current_date, OR a sine-die flag set —
   implement as an AFTER INSERT/UPDATE trigger on hearings/hearing_outcomes
   that raises an exception if this invariant would be violated (this backs
   PRD AC-CC3, an integrity job also checks nightly, but the trigger is the
   hard guarantee).
 - evidence_custody_log as append-only (trigger blocking UPDATE/DELETE).
 - matter_important_dates with a trigger blocking DELETE when due_at is within
   30 days (BR-2) — only status-satisfied update allowed.
```

### PROMPT DB-5 — DMS schema (documents)
```
Read LexFlow_PRD.md §18 (dms.* tables), Module 7 in full. Build every object
under 05_DMS/. Implement: documents.current_version_id FK to
document_versions with a trigger keeping it in sync; document_versions
UNIQUE(document_id, version_no) and append-only (no UPDATE/DELETE of blob_path
or hash once inserted — only new rows); document_permissions supporting
principal_type IN ('user','team','role','portal_client','link'); a partial
index on documents(confidentiality) WHERE confidentiality='Privileged' to
support the privileged-content shield queries fast.
```

### PROMPT DB-6 — Fin schema (billing, time, trust accounting)
```
Read LexFlow_PRD.md §18 (fin.* tables), Module 8 and Module 9 in full —
this is the highest-risk schema, implement every guardrail literally:
 - invoices/invoice_lines/invoice_taxes/payments/payment_allocations/
   credit_notes/refunds/dunning_schedules/dunning_events/rate_cards/
   rate_card_entries/billing_arrangements/tax_configs/number_series/
   time_entries/running_timers/activity_codes — full Table/Indexes/
   Constraints/Triggers per object.
 - payments.idempotency_key UNIQUE(tenant_id, idempotency_key).
 - a trigger on invoices blocking any UPDATE of lines/totals once
   status NOT IN ('Draft') — only status transitions and void allowed
   (BR-4 invoice immutability).
 - a trigger on time_entries blocking UPDATE/DELETE once status='Billed'
   (BR-5).
 - trust_accounts + trust_ledger_entries: entry_no as a per-account
   bigserial-like running sequence, running_balance maintained by trigger,
   a BEFORE INSERT trigger on disbursement rows that locks the trust_account
   row (SELECT ... FOR UPDATE) and raises exception INSUFFICIENT_TRUST_BALANCE
   if amount > current balance, and a second trigger that makes the table
   fully append-only (RAISE EXCEPTION on any UPDATE or DELETE attempt,
   exactly as specified in PRD §18 and required by AC-B7 / BR-3).
 Write a short SQL comment above each trigger citing the PRD business rule
 (BR-x / AC-x) it enforces, so the trigger's intent is traceable.
```

### PROMPT DB-7 — Ops schema (tasks, calendar, workflow, notifications)
```
Read LexFlow_PRD.md §18 (ops.* tables), Module 6, Module 10, §23. Build every
object under 07_Ops/. Implement: task_dependencies with an INSERT trigger
that walks the dependency graph (recursive CTE) and raises CYCLE_DETECTED if
adding the edge would create a cycle (backs AC-TK2/PRD §Module 10 edge case);
calendar_events + recurrence_exceptions modeled per §18; reminder_dispatch_log
as a table PARTITION BY RANGE(sent_at) with a helper function to create the
next month's partition (used later by a scheduled job).
```

### PROMPT DB-8 — Comm schema
```
Read LexFlow_PRD.md §18 (comm.* abridged list), Module 11 in full. Build every
object under 08_Comm/. Implement email_messages PARTITION BY RANGE(sent_at)
with UNIQUE(message_id_hdr) per partition strategy note; whatsapp_messages
UNIQUE(wa_msg_id); chat_messages with a simple sequence-based ordering column
for pagination.
```

### PROMPT DB-9 — Knowledge Base schema
```
Read LexFlow_PRD.md §18 (kb.* tables), Module 12 in full. Build every object
under 09_KB/. Implement kb_act_sections as self-referencing (parent_id) with
ltree path column for fast subtree queries; kb_judgments
UNIQUE(tenant_id, citation); kb_articles with status CHECK IN
('Draft','InReview','Published') and a trigger preventing publish when
reviewer_id = author_id (peer-review rule from Module 12).
```

### PROMPT DB-10 — Audit schema
```
Read LexFlow_PRD.md §18 (audit.audit_events), §30 in full. Build 10_Audit/
AuditEvents/ with: 001_Table.sql defining audit_events PARTITION BY
RANGE(at) with all columns from §18/§30 (actor_user_id, actor_type, action,
entity_type, entity_id, before/after jsonb, ip, ua, trace_id); 002_Indexes.sql
(tenant_id, entity_type, entity_id, at DESC); 003_Insert_Only_Trigger.sql
that revokes UPDATE/DELETE at the grant level (REVOKE UPDATE, DELETE ON
audit.audit_events FROM PUBLIC; only an INSERT-granted app role may write) —
implement as both a trigger AND a role-grant statement for defense in depth.
Also create a monthly-partition-creation SQL function
audit.fn_ensure_partition(month date) to be called by a scheduled job.
```

### PROMPT DB-11 — Row-Level Security policies
```
Read LexFlow_PRD.md §14, §20(5). For every tenant-scoped table across all
schemas created in DB-2 through DB-10, generate 15_RLS_Policies/ scripts
(one file per schema: 001_Core_RLS.sql, 002_CRM_RLS.sql, ... 009_KB_RLS.sql)
that: ALTER TABLE ... ENABLE ROW LEVEL SECURITY; and
CREATE POLICY tenant_isolation ON <table> USING
(tenant_id = current_setting('app.tenant_id')::uuid);
Also add a FORCE ROW LEVEL SECURITY so even the table owner role is
constrained (the API's Postgres role must not be superuser). Generate the
list programmatically by scanning table names already created rather than
hand-typing — but since you're generating SQL text directly, enumerate every
table explicitly from the Build Playbook §1.1 tree so nothing is missed.
```

### PROMPT DB-12 — Views & materialized views
```
Read LexFlow_PRD.md Module 1 (dashboard widgets), §13 Reports. Create
11_Views/ with v_calendar_items (UNION of calendar_events, hearings,
matter_important_dates, tasks-with-due-date, projected as a common shape) per
§Module 6. Create 12_MaterializedViews/ with mv_dashboard_revenue,
mv_dashboard_outstanding, mv_case_stats (per §Module 1 widgets) — each with a
matching CREATE UNIQUE INDEX so REFRESH MATERIALIZED VIEW CONCURRENTLY works,
and a comment noting the 5-minute refresh cadence to be scheduled via Hangfire
in the API/Workers project (not pg_cron, to keep infra simple).
```

### PROMPT DB-13 — Functions & global triggers
```
Read LexFlow_PRD.md FR-007 (number series), §17 (rate resolution BR-7), §14.
Create 13_Functions/ with: fn_next_number(series_key text, tenant uuid,
branch uuid) implementing the {BRANCH}{FY}{seq} pattern engine described in
§18 number_series design and FR-007, using a per-series sequence created
dynamically; fn_resolve_time_entry_rate(...) implementing the precedence
chain from BR-7. Create 14_Triggers_Global/ with a reusable
trg_set_updated_at() function + a script that ATTACHES it to every mutable
table across all schemas (enumerate tables explicitly, same approach as DB-11).
```

### PROMPT DB-14 — Seed data
```
Read LexFlow_PRD.md §21 (roles/permissions), Module 5 (courts), Module 9
(activity codes), Module 8 (tax configs — India GST), §14. Create 16_Seed/
with numbered scripts seeding: 001_Permissions_Catalog.sql (every
module.action.scope permission string implied by §21's matrix),
002_System_Roles.sql (Owner, Admin, SeniorPartner, Partner, Lawyer,
Paralegal, Receptionist, Finance, HR, Auditor + role_permissions wiring
matching §21 exactly), 003_Courts_India.sql (Supreme Court, all 25 High
Courts, sample District Courts, NCLT/NCLAT/ITAT/CAT/Consumer/Family/Labour
tribunal types), 004_Practice_Areas.sql (Civil, Criminal, Corporate, Family,
IP, Tax, Labour, Real Estate, Arbitration, Compliance), 005_Activity_Codes.sql
(Drafting, Court Appearance, Research, Client Call, Review, Filing, Admin),
006_Tax_Configs_India_GST.sql (CGST 9%, SGST 9%, IGST 18% as a starter
template tenants clone), 007_Lost_Reasons.sql, 008_Demo_Tenant.sql (one demo
tenant + one demo branch, matching the seed factory described in §37, sized
small — full 200-client/1k-matter volume is generated by the API-side seeder
in a later prompt, not raw SQL).
```

### PROMPT DB-15 — Reporting star schema
```
Read LexFlow_PRD.md §13 (reporting star schema fact/dim tables). Create
17_Reporting_StarSchema/ with rpt_dim_date, rpt_dim_lawyer, rpt_dim_client,
rpt_dim_practice_area, rpt_fact_billing, rpt_fact_time, rpt_fact_matters —
each with the Table/Indexes files, and a comment block explaining these are
populated by an hourly incremental job in LexFlow.Workers (built in an API
phase prompt, not here).
```

### PROMPT DB-16 — Runner finalization & CI gate
```
Update Runner/LexFlow.Database.Runner to also expose a --verify-only mode
that applies all scripts to a throwaway Testcontainers Postgres instance and
then runs a generated assertion script checking: every table has tenant_id +
audit columns except lookup/seed tables explicitly whitelisted; every table
referenced by an RLS script in 15_RLS_Policies actually has RLS enabled
(cross-check table list); trust_ledger_entries and audit_events reject
UPDATE/DELETE via a live test transaction. Wire this --verify-only run into
.github/workflows/db-migrate.yml as a required PR check.
```

---

## PHASE C — API Build Prompts (`lexflow-api`)

Each prompt builds one vertical slice through all four layers (Domain → Application → Infrastructure → Api) for the named module, wired against the schema built in Phase B. Always instruct: *"Entities map to the existing lexflow-database schema; do not generate EF migrations."*

### PROMPT C-1 — Auth & RBAC foundation
```
Read LexFlow_PRD.md §20, §21, FR-002/003, Module 14. In LexFlow.Domain add
User, Role, Permission, Team, Department, Branch entities matching
02_Core schema exactly (column-for-column). In LexFlow.Infrastructure add
EF Core entity configurations (Fluent API, table/schema names matching SQL),
Npgsql DbContext with a SetTenantId(Guid) extension that executes
SET app.tenant_id per §14/§20 at the start of each request scope. Implement
ASP.NET Identity integration for password hashing (Argon2id per §20), JWT
issuance (RS256, 15-min access + 7-day rotating refresh with reuse-detection
per §20(3)), TOTP 2FA (RFC 6238) enrollment/verify endpoints, and a
PermissionRequirement/PermissionHandler pair implementing the
module.action.scope authorization model from §21 (custom [RequirePermission]
attribute usable on controllers). In LexFlow.Api implement
POST /api/v1/auth/login, /refresh, /logout, /forgot, /reset, /2fa/setup,
/2fa/verify, GET /auth/me exactly per the contract in §17. Write unit tests
for the permission handler covering every row of the §21 matrix
(this seeds the G-AC4 test suite).
```

### PROMPT C-2 — Audit interceptor & error envelope (cross-cutting)
```
Read LexFlow_PRD.md §17 (error envelope), §28, §29, §30. Implement a
SaveChangesInterceptor in LexFlow.Infrastructure that writes one
audit.audit_events row per entity mutation (before/after jsonb diff, actor
from current HttpContext, trace_id from Activity.Current) inside the same
transaction as the business change (FR-004/§30). Implement global exception
middleware in LexFlow.Api mapping domain exceptions to the §17 envelope with
correct HTTP codes (§28 table), Serilog structured logging with the
redaction rules from §29 (no bodies/passwords/tokens/narratives logged),
OpenTelemetry trace propagation. Write integration tests proving a scripted
25-entity-type scenario produces zero audit gaps (G-AC5).
```

### PROMPT C-3 — Admin module (users, roles, teams, branches, settings)
```
Read LexFlow_PRD.md Module 14, Module 15 in full. Implement the full CQRS
vertical slice (commands/queries/handlers/validators/DTOs/controllers) for
every API listed in those modules' API sections, against the 02_Core schema.
Include the deactivation-with-reassignment wizard (AC-U1/U3), the
effective-permissions inspector endpoint, and all 15 Settings sections with
per-section JSON-schema validation and the SMTP/SMS/WhatsApp/gateway
test-send endpoints (with live external calls behind interfaces so they're
mockable in tests).
```

### PROMPT C-4 — CRM module (leads, clients)
```
Read LexFlow_PRD.md Module 2, Module 3 in full. Implement the full CQRS
vertical slice against 03_CRM schema, including: duplicate-check endpoint
(pg_trgm fuzzy match), the lead conversion transaction (client + optional
matter + optional invoice, atomic, per AC-L3), CSV/XLSX import pipeline
(background job via Hangfire, per-row validation, error-CSV generation),
client merge with full re-parenting across matters/invoices/documents/
activities (AC-C3), and KYC document field-level encryption using the
pgcrypto-backed columns from DB-3 (encrypt/decrypt via Infrastructure
service, key from Key Vault).
```

### PROMPT C-5 — Legal module (matters, court cases, hearings)
```
Read LexFlow_PRD.md Module 4, Module 5 in full — this is the module where
G-AC2 (date safety) is non-negotiable. Implement the full CQRS vertical
slice against 04_Legal schema, including: conflict-check endpoint (Elasticsearch
fuzzy match over matter_parties/client names, wired in C-9), the
matter-closing checklist workflow, the hearing-outcome endpoint that in one
transaction creates the next hearing (if given) + writes
event_reminders/ops rows for 30/7/1/day-of + optionally creates a compliance
task (calls into Ops module service, C-7) — exactly per the contract in §17
POST /hearings/{id}/outcome. Write a G-AC2 integration test: create a
hearing via every code path (API, import, mobile-offline-sync simulation)
and assert reminders exist in the same transaction.
```

### PROMPT C-6 — DMS module (documents)
```
Read LexFlow_PRD.md Module 7 in full. Implement the full CQRS vertical slice
against 05_DMS schema: multipart upload → Azure Blob store → AV scan
(ClamAV sidecar client interface) → text extraction (native PDF text via
PdfPig or OCR via Tesseract worker queued through Hangfire) → Elasticsearch
indexing (outbox pattern: write an outbox row in the same transaction as the
document insert, a background dispatcher publishes to Service Bus/queue,
an indexer worker consumes and calls ES). Implement versioning, share-links
(with expiry/password/watermark flags), template merge (OpenXML-based docx
merge), and the DocuSign/Adobe Sign ISignatureProvider abstraction with a
webhook endpoint per §17/§34. Enforce the privileged-content and
confidentiality gating in every query (AC-DOC3).
```

### PROMPT C-7 — Ops module (tasks, calendar, workflow engine, notifications)
```
Read LexFlow_PRD.md Module 6, Module 10, §23, §22 in full. Implement the
full CQRS vertical slice against 07_Ops schema: task CRUD with dependency
cycle-check delegated to the DB trigger (catch and surface as
CYCLE_DETECTED), calendar CRUD with RRULE expansion (use a maintained RRULE
library, materialize occurrences 24 months rolling per §Module 6), Google
Calendar + Microsoft Graph two-way sync services implementing ICalendarSync,
the Workflow Rule engine (trigger/condition/action interpreter reading
workflow_rules JSON, executed by a Hangfire-driven worker consuming domain
events from the outbox), and the unified NotificationService implementing
the full §22 matrix (channel fallback chain, quiet hours, per-user
preference overrides) fanning out to Email/SMS/WhatsApp/Push/In-app
providers (interfaces only here; concrete providers wired in C-8/C-13).
Ship the 12 default workflow rules from §23 as seed JSON, loaded by a
one-time migration-style seeding command (not raw SQL — application-level).
```

### PROMPT C-8 — Comm module (email, SMS, WhatsApp, chat)
```
Read LexFlow_PRD.md Module 11 in full. Implement the full CQRS vertical
slice against 08_Comm schema: Gmail API + Microsoft Graph mailbox sync
services (IEmailSync), BCC-dropbox inbound handler with matter
auto-matching + Triage queue for ambiguous matches, Twilio/MSG91 SMS
provider (ISmsProvider) with India DLT template enforcement, WhatsApp
Cloud API provider (session vs template/HSM logic, opt-in ledger check
before every template send), Twilio Voice click-to-call, and SignalR-backed
internal chat (channels, DMs, per-matter auto-channels) via the
/hubs/chat hub scaffolded in A-2. Wire all inbound webhooks through the
single /api/v1/webhooks/{provider} router with HMAC verification and
event-id dedupe per §34.
```

### PROMPT C-9 — Fin module (billing, time, trust, payments)
```
Read LexFlow_PRD.md Module 8, Module 9 in full — implement every guardrail
in application code as well as relying on the DB triggers from DB-6 (defense
in depth; never trust the DB alone for business messaging — catch trigger
exceptions and translate to the §17 sub-codes). Implement: timer
start/pause/resume/stop with server-anchored timestamps, timesheet +
approval workflow (segregation of duties: approver != submitter), the
batch-billing engine (WIP pull, milestone/retainer line generation, GST
CGST/SGST/IGST place-of-supply logic per BR-9), invoice approval workflow,
PDF generation (QuestPDF) matching firm branding from Settings, Stripe +
Razorpay + PayPal IPaymentGateway implementations with idempotent webhook
handlers (payment.captured → allocate → mark paid, exactly-once via
gateway event-id store), dunning scheduler (Hangfire recurring job reading
dunning_schedules), and the trust deposit/disbursement endpoints with
dual-control (second approver) support for Enterprise tier. Write the
FsCheck property-based tests from §37 (allocation never exceeds, trust never
negative under concurrency, invoice totals reconcile) as part of this prompt,
not later — these are the highest-risk invariants in the whole system.
```

### PROMPT C-10 — Knowledge Base module
```
Read LexFlow_PRD.md Module 12 in full. Implement the full CQRS vertical
slice against 09_KB schema: Acts/Sections CRUD with as-on-date historical
rendering (effective_from/effective_to), judgment upload with OCR fallback,
article draft→review→publish workflow (reviewer≠author enforced at both DB
trigger and application layer), Elasticsearch-backed KB search with
citation-format-aware query parsing, and the matter-pin endpoint that
snapshots text at pin time (per AC-KB4/edge case in §Module 12).
```

### PROMPT C-11 — Reports module
```
Read LexFlow_PRD.md §13, Module 13 in full. Implement the reports catalog
API, the 12 standard reports as parameterized queries against
17_Reporting_StarSchema (built in DB-15) with row-level scope injection
(a runner's report data must be pre-filtered by their §21 scope — implement
as a predicate-injection layer, this backs the report security rule and
G-AC1 reconciliation tests), the custom report builder (whitelisted field
catalog only — never raw SQL from the client), async job execution for
heavy runs (>120s auto-converts to Hangfire job + email-on-complete), and
PDF/XLSX/CSV export (QuestPDF/ClosedXML/CsvHelper). Implement the hourly
incremental job that populates the star schema fact tables from the OLTP
schemas built in DB-2 through DB-9.
```

### PROMPT C-12 — AI module (AI gateway)
```
Read LexFlow_PRD.md Module 16 in full. Implement LexFlow.AI as an internal
gateway service: ILlmProvider abstraction (Anthropic Claude primary),
pgvector-backed RAG store with tenant namespacing + RBAC-filtered retrieval
(retrieval must call the same permission-check used by the record's normal
read endpoint — no separate, weaker path), the 12 AI features as
CQRS handlers wrapping prompt templates (store templates as versioned YAML
under /ai/prompts per §35), citation verifier (cross-checks any cited
kb_judgments/document id actually exists and is retrievable by the caller
before returning it), ai_interactions audit table writer, per-tenant
AI-credit quota enforcement (402 AI_QUOTA_EXCEEDED), and the
Whisper-class transcription pipeline (async, Hangfire job, webhook/SignalR
notify on completion). Every AI response must carry the "AI-generated"
badge flag in its DTO per BR-19 — write a test asserting no AI response DTO
can omit it.
```

### PROMPT C-13 — Workers: background jobs
```
Read LexFlow_PRD.md across all modules for anything described as
"nightly", "background", "scheduled", or "async". In LexFlow.Workers,
implement Hangfire recurring/queued jobs for: reminder dispatch (reads
event_reminders/matter_important_dates, sends via NotificationService,
writes reminder_dispatch_log — this job's failure rate is a page-worthy
alert per §29), dunning execution, document OCR/AV/indexing pipeline
consumers, materialized-view refresh (every 5 min), star-schema
incremental build (hourly), workflow-rule execution consumer, calendar
sync polling fallback, trust/audit nightly integrity checks (G-AC1/G-AC2
assertions, alert on violation), and reporting-partition maintenance
(monthly partition creation for audit_events/email_messages/
reminder_dispatch_log). Add a Hangfire Dashboard secured behind
`settings.manage` permission.
```

### PROMPT C-14 — Portal API (separate audience)
```
Read LexFlow_PRD.md Module 17 in full. Implement /api/portal/v1/* as a
distinct set of controllers using a separate JWT audience ("portal") and a
separate refresh-cookie domain, with every handler deriving client_id
exclusively from the token (never from the request payload — write an IDOR
test suite per AC-P1 covering every portal endpoint). Implement the
sanitized-timeline projection (publish flags only), Pay-Now gateway session
creation + return-URL reconciliation (race-safe per the edge case in
§Module 17), document upload-from-client pipeline, appointment request
flow, and secure messaging threads.
```

### PROMPT C-15 — Integration test suite & security gates
```
Read LexFlow_PRD.md §37, G-AC1 through G-AC10 in §8. Implement the global
cross-cutting test suites as their own IntegrationTests fixtures: a
cross-tenant fuzz test that hits every controller action with a
foreign-tenant id and asserts 404/403 (G-AC3), a generator that reads the
§21 matrix (persist it as permissions_matrix.json) and asserts every
(role, endpoint) pairing behaves as specified (G-AC4), the money-integrity
nightly-job assertion as an integration test too (G-AC1), and a
Testcontainers-based full-stack smoke test (Postgres+Redis+ES) exercising
lead→convert→matter→hearing→outcome and WIP→invoice→pay end to end.
```

### PROMPT C-16 — OpenAPI, Docker, CI/CD finalization
```
Finalize Swashbuckle to emit a complete OpenAPI 3.1 document at /swagger
covering every endpoint built in C-1 through C-14, grouped by tag matching
§16's Area column. Generate a typed TypeScript client (openapi-typescript
or NSwag) into an artifact the lexflow-web repo will consume (publish as a
versioned npm package or a copyable generated/ folder — document the choice
in README). Finalize docker-compose for full local stack (api + workers +
postgres + redis + elasticsearch + azurite for blob emulation). Finalize
.github/workflows/api-ci.yml with the full gate sequence from §37
(build → unit → integration → Sonar → contract → security scans) and a
deploy job implementing the blue-green strategy described in §38.
```

---

## PHASE D — UI Build Prompts (`lexflow-web`)

Each prompt builds one feature module end-to-end (routing, state via signals, services calling the generated OpenAPI client, components per §12 design system). Always instruct: *"Use the typed API client from lexflow-api; do not hand-write HTTP calls."*

### PROMPT D-1 — Auth & shell finalization
```
Read LexFlow_PRD.md §11 (auth & shell screens), §12, §13, §20. Implement
Login, 2FA challenge, Forgot/Reset password, Accept invitation screens in
staff-portal against the C-1 auth endpoints. Implement the JWT
access/refresh interceptor (silent refresh, redirect-to-login on failure),
the PermissionService-driven nav trimming per §13, the global ⌘K search
overlay (stub calling GET /search), the persistent timer chip component
(state service polling GET /timers/current + SignalR), and the notification
bell (SignalR /hubs/notifications + GET /notifications).
```

### PROMPT D-2 — Dashboard module
```
Read LexFlow_PRD.md Module 1 in full. Implement the dashboard feature:
widget catalog, drag-drop customizable grid (persisted via
PUT /dashboard/layout), all 12 widgets as independent lazy-loading
components each with its own loading/error/empty state (per AC-D1/D5),
SignalR live-update subscription for hearing outcomes/payments, and the
date-range selector affecting analytic widgets.
```

### PROMPT D-3 — Leads module
```
Read LexFlow_PRD.md Module 2 in full. Implement: Kanban board (Angular CDK
drag-drop, stage-aging colors), list view with saved filters, lead detail
3-pane layout, quick-log call/note/meeting dialogs, the 3-step conversion
wizard, CSV/XLSX import wizard with mapping + error-file download, duplicate
merge dialog, lost-reason dialog. Wire every UI validation rule to mirror
the shared validation-catalog described in §27 (build
libs/shared/validation-catalog.ts consumed by reactive-form validators).
```

### PROMPT D-4 — Clients module
```
Read LexFlow_PRD.md Module 3 in full. Implement: client list (card/table
toggle, alpha index), create stepper (Basic→KYC→Addresses→Portal), 360°
detail with all 8 tabs, contact-person sub-grid, KYC document manager
(upload + expiry badges + verify action), relationship graph (simple
node-link render), merge wizard, portal-access manager (invite/resend).
```

### PROMPT D-5 — Matters & Court Cases module
```
Read LexFlow_PRD.md Module 4, Module 5 in full — this is the most complex
UI in the product. Implement: matter list with saved views, create dialog
with conflict-check inline results, the matter workspace with all 10 tabs
(header with next-hearing countdown chip that color-shifts green→amber→red
per §12 micro-interactions), the closing checklist dialog blocking close
until satisfied, important-dates side panel with severity badges, the
court-case detail tabs (hearings/orders/parties/evidence/witnesses/
arguments), the hearing-outcome dialog (next-date picker aware of court
holidays), and the printable cause-list day view.
```

### PROMPT D-6 — Calendar module
```
Read LexFlow_PRD.md Module 6 in full. Implement a custom virtualized
month/week/day/agenda calendar (no heavy third-party dependency), RRULE
builder UI for recurring events, drag-to-reschedule (disabled for hearings
per the locked rule), sync-settings page (Google/Microsoft connect flows),
reminder-policy editor, and ICS export settings.
```

### PROMPT D-7 — Documents module
```
Read LexFlow_PRD.md Module 7 in full. Implement: folder/file explorer
(tree+list/grid, breadcrumbs, keyboard nav), drag-drop multi-file uploader
with per-file pipeline-status chips, detail drawer (metadata/versions/
activity/sharing), pdf.js-based preview modal with search-hit highlighting,
template gallery + merge wizard, share dialog, signature wizard, bulk
action toolbar.
```

### PROMPT D-8 — Billing & Trust module
```
Read LexFlow_PRD.md Module 8 in full. Implement: billing hub with all
tabs, invoice editor (line grid + live tax panel + PDF preview pane),
batch-billing wizard, payment-record dialog with allocation grid, client
statement view, aging report grid, trust ledger view (color-coded entries,
running balance), and the reconciliation workspace (CSV import → auto-match
→ exceptions list → sign-off). Enforce typed-confirmation for void/refund
actions per §12.
```

### PROMPT D-9 — Time Tracking module
```
Read LexFlow_PRD.md Module 9 in full. Implement the persistent timer
component (already stubbed in D-1) fully: stop dialog with rounding
preview, the virtualized weekly timesheet grid (keyboard-first
arrows+enter navigation), entry list with filters, approval queue with
bulk-approve, and the utilization dashboard cards.
```

### PROMPT D-10 — Tasks module
```
Read LexFlow_PRD.md Module 10 in full. Implement: task composer with the
smart-parse text box (calls POST /tasks/parse and shows structured
preview before creating), detail drawer (checklist/comments/dependencies
mini-graph), Kanban board, workload board (assignee columns), recurring
editor, and template manager.
```

### PROMPT D-11 — Communication module
```
Read LexFlow_PRD.md Module 11 in full. Implement: three-pane email inbox,
composer with template picker + merge preview, thread view with
matter-link banner, SMS/WhatsApp chat-style panes with template/variable
fill, call-log dialog, the collapsible chat dock (SignalR-backed,
unread badges), and the reusable communication-timeline component (also
used embedded in Client/Matter 360° from D-4/D-5 — refactor those to import
it).
```

### PROMPT D-12 — Knowledge Base module
```
Read LexFlow_PRD.md Module 12 in full. Implement: search-first KB home,
Act reader (section tree + reader pane + as-on-date selector), judgment
reader (metadata header + pdf.js viewer + "cited in N matters"), collection
boards, the pin-from-matter dialog (called from D-5's matter workspace
Research tab), and the contribution editor with review-workflow states.
```

### PROMPT D-13 — Reports module
```
Read LexFlow_PRD.md Module 13, §24 in full. Implement: reports hub
(catalog cards, favorites), report viewer (parameter bar, chart/table
toggle via Chart.js, drill-down links, export menu), the 4-step custom
report builder, schedule dialog, and saved-report manager.
```

### PROMPT D-14 — Admin & Settings module
```
Read LexFlow_PRD.md Module 14, Module 15 in full. Implement: users list +
detail + invite flow, the permission-matrix viewer + custom-role builder
(Enterprise), teams/departments/branches CRUD, sessions & login-history
browser, the effective-permission inspector ("why can X see this?" trace
view), all 15 settings sections as sub-screens with live-verify buttons
(SMTP/SMS/WhatsApp/gateway test-send), the workflow-rules visual builder
(trigger picker → condition groups → action-step cards → simulate),
and the audit-log browser.
```

### PROMPT D-15 — AI Studio module
```
Read LexFlow_PRD.md Module 16 in full. Implement: the context-aware AI
assistant side panel (SSE streaming chat, / commands, citation links),
the contract-review workspace (clause extraction table + risk flags +
tracked-changes redline output), the draft studio (guided intake form →
generated draft editor with regenerate-per-section), and the research
workspace (question → cited answer, "no authority found" empty state).
Every AI output component must render the AI-badge and require an explicit
Save/Insert action per BR-19 — do not wire any auto-apply path.
```

### PROMPT D-16 — Client Portal app
```
Read LexFlow_PRD.md Module 17 in full. Build out the client-portal app
scaffolded in A-3 completely: home, matter list/timeline (sanitized),
invoices + Pay Now (gateway checkout redirect/embed), documents
(view+upload), appointments (request + confirm), secure messages, and
preferences. Firm-branded theming pulled from GET /portal/v1/branding
(logo/colors from Settings). Ensure zero staff-only data paths are
reachable — reuse the shared design system but keep client-portal's data
layer entirely separate from staff-portal's (per the identity-separation
rule in §20).
```

### PROMPT D-17 — PWA, i18n, accessibility, performance pass
```
Read LexFlow_PRD.md §12, §31, §33 (WCAG), FR-012. Finalize PWA behavior
(installable, offline shell + cached reads for dashboard/calendar,
background sync of queued mutations) on both apps. Complete en/hi i18n
catalogs for all screens built in D-1 through D-16 (run extraction, fill
translations, add the pseudo-locale CI check from G-AC8). Run an
axe-core pass across the top 30 screens (§11 list) and fix all critical
violations (G-AC7). Verify bundle-size budgets per §31 and add
route-level code-splitting anywhere a lazy chunk exceeds budget.
```

### PROMPT D-18 — E2E test suite
```
Read LexFlow_PRD.md §37 (E2E journeys). Implement the 40 critical
Playwright journeys against the full local stack (docker-compose from
lexflow-api + lexflow-web dev servers), including the two flagged as
highest-value: lead→convert→matter→hearing→outcome, and
WIP→invoice→pay(Razorpay test mode)→receipt. Wire into
.github/workflows/web-ci.yml as a required check before deploy.
```

### PROMPT D-19 (optional) — Mobile app kickoff (`lexflow-mobile`)
```
Read LexFlow_PRD.md Module 18 in full. Create a new repository
"lexflow-mobile" as a Flutter app consuming the same OpenAPI-generated
client (via a Dart client generator) plus the SignalR hubs. Implement the
offline-first architecture (drift/SQLite local DB, write-queue with
client-generated UUIDs, sync engine per §Module 18's conflict rules),
biometric-gated secure token storage, the Today view, hearing
outcome capture (offline-capable), document scanner (edge-detect →
PDF → queued upload), voice notes, timers, tasks, calendar, lead
quick-capture, and the approvals inbox. Ship push notification wiring
(FCM/APNs) last, once the core offline sync loop is proven by the
AC-MB1 airplane-mode test.
```

---

## PHASE E — Final Integration & Launch Prompts

### PROMPT E-1 — Cross-repo environment wiring
```
Across lexflow-database, lexflow-api, lexflow-web: produce a top-level
docker-compose.full.yml (or a lightweight docs/local-dev.md if you keep
repos fully independent) that boots Postgres → runs the DB Runner →
starts the API+Workers → starts both Angular dev servers, in that
dependency order, with health-check gating between steps. Document the
three repos' versioning/release relationship (which API version pairs
with which DB schema version pairs with which UI build) in a
COMPATIBILITY.md at the root of each repo.
```

### PROMPT E-2 — Staging deploy & smoke
```
Read LexFlow_PRD.md §38. Wire the three repos' CI/CD pipelines to deploy
to a shared staging environment on AKS (API+Workers), Azure Static Web
Apps or equivalent (both Angular apps), and the managed Postgres Flexible
Server (DB Runner as a pre-deploy job). Run the D-18 Playwright suite and
the C-15 integration suite against staging as the release gate before
promoting to the blue-green production deploy described in §38.
```

### PROMPT E-3 — Pilot readiness checklist
```
Read LexFlow_PRD.md §3 (success metrics), §8 (global ACs), §37 (UAT).
Produce a PILOT_READINESS.md checklist enumerating: every G-AC1–G-AC10
test passing in CI, every module's Acceptance Criteria (§6) mapped to a
passing automated test (traceability table), SOC 2 Type I control
evidence collected (§33), and the seed demo tenant (DB-14/C-Reports
seeder) loaded and walkthrough-able end to end by a non-technical
reviewer using only the PRD's persona scripts (§4).
```

---

## Execution Order Summary

| Order | Repo | Prompts | Depends on |
|---|---|---|---|
| 1 | lexflow-database | A-1, DB-1…DB-16 | — |
| 2 | lexflow-api | A-2, C-1…C-16 | DB schema applied |
| 3 | lexflow-web | A-3, D-1…D-19 | API OpenAPI client published |
| 4 | all | E-1…E-3 | all of the above |

Total: **3 scaffold + 16 database + 16 API + 19 UI + 3 integration ≈ 57 prompts** to take LexFlow from empty repos to a pilot-ready, tested, deployed system.

*End of Build Playbook.*
