-- PROMPT DB-14. PRD §21 (Roles & Permissions Matrix), §20 AuthZ: "permission
-- format module.action.scope". Every permission string implied by §21's
-- matrix, one row per (module, action, scope) combination that actually
-- appears against some role in the matrix (Scopes: O=own, T=team, B=branch,
-- A=all).
--
-- core.permissions is tenant-scoped (tenant_id NOT NULL, no physical FK —
-- see 02_Core/Tenants/001_Table.sql), so this catalog is seeded against a
-- single well-known demo tenant id, reused identically across every file in
-- this folder. 008_Demo_Tenant.sql creates the actual core.tenants row for
-- that id — there is no FK enforcing load order, so this is safe to seed
-- first (matching the prompt's explicit 001→008 file numbering) as long as
-- every file in the folder agrees on the same id, which they all do.
--
-- Client(Portal) is not represented here: it is a distinct actor type
-- (§21 header: "Client(Portal)") authorized through crm.client_portal_users
-- + matter-visibility scoping in the portal API, not through core.roles /
-- core.role_permissions — so its column in the matrix has no corresponding
-- role in 002_System_Roles.sql either.
--
-- Some cells carry a qualifier beyond plain O/T/B/A (e.g. "B(C,R-own-
-- created)", "T(if member)", "fin fields", "published", "+2FA", "dual").
-- Those qualifiers are business/API-layer authorization refinements on top
-- of the base scope, not additional scope values (the scope column only
-- supports own/team/branch/all/special) — each such cell is catalogued
-- against the nearest of own/team/branch/all, with the qualifier preserved
-- in the label for traceability back to §21.
WITH demo AS (
  SELECT '00000000-0000-0000-0000-000000000001'::uuid AS tenant_id
)
INSERT INTO core.permissions (tenant_id, key, module, action, scope, label)
SELECT demo.tenant_id, v.key, v.module, v.action, v.scope, v.label
FROM demo CROSS JOIN (VALUES
  -- leads
  ('leads.read.own', 'leads', 'read', 'own', 'Read own leads'),
  ('leads.read.team', 'leads', 'read', 'team', 'Read team leads'),
  ('leads.read.all', 'leads', 'read', 'all', 'Read all leads'),
  ('leads.create.own', 'leads', 'create', 'own', 'Create leads (own)'),
  ('leads.create.team', 'leads', 'create', 'team', 'Create leads (team)'),
  ('leads.create.branch', 'leads', 'create', 'branch', 'Create leads (branch) — Reception: read limited to own-created'),
  ('leads.create.all', 'leads', 'create', 'all', 'Create leads (all)'),
  ('leads.update.own', 'leads', 'update', 'own', 'Update own leads'),
  ('leads.update.team', 'leads', 'update', 'team', 'Update team leads'),
  ('leads.update.all', 'leads', 'update', 'all', 'Update all leads'),
  ('leads.convert.own', 'leads', 'convert', 'own', 'Convert own leads'),
  ('leads.convert.team', 'leads', 'convert', 'team', 'Convert team leads'),
  ('leads.convert.all', 'leads', 'convert', 'all', 'Convert any lead'),

  -- clients
  ('clients.read.own', 'clients', 'read', 'own', 'Read own clients'),
  ('clients.read.team', 'clients', 'read', 'team', 'Read team clients'),
  ('clients.read.all', 'clients', 'read', 'all', 'Read all clients — Reception: name-only fields'),
  ('clients.create.own', 'clients', 'create', 'own', 'Create clients (own)'),
  ('clients.create.team', 'clients', 'create', 'team', 'Create clients (team)'),
  ('clients.create.all', 'clients', 'create', 'all', 'Create clients (all)'),
  ('clients.update.own', 'clients', 'update', 'own', 'Update own clients'),
  ('clients.update.team', 'clients', 'update', 'team', 'Update team clients'),
  ('clients.update.all', 'clients', 'update', 'all', 'Update all clients'),

  -- client KYC (identity documents) — separate module: privileged-content shield blocks Admin
  ('clients_kyc.read.own', 'clients_kyc', 'read', 'own', 'Read own clients'' KYC docs'),
  ('clients_kyc.read.team', 'clients_kyc', 'read', 'team', 'Read team clients'' KYC docs'),
  ('clients_kyc.read.all', 'clients_kyc', 'read', 'all', 'Read all clients'' KYC docs (Admin excluded by shield)'),

  -- matters
  ('matters.read.own', 'matters', 'read', 'own', 'Read own matters'),
  ('matters.read.team', 'matters', 'read', 'team', 'Read team matters'),
  ('matters.read.all', 'matters', 'read', 'all', 'Read all matters (Admin excluded by shield; Finance limited to financial fields)'),
  ('matters.create.own', 'matters', 'create', 'own', 'Create matters (own)'),
  ('matters.create.team', 'matters', 'create', 'team', 'Create matters (team)'),
  ('matters.create.all', 'matters', 'create', 'all', 'Create matters (all)'),
  ('matters.update.own', 'matters', 'update', 'own', 'Update own matters'),
  ('matters.update.team', 'matters', 'update', 'team', 'Update team matters'),
  ('matters.update.all', 'matters', 'update', 'all', 'Update all matters'),
  ('matters.close.team', 'matters', 'close', 'team', 'Close team matters'),
  ('matters.close.all', 'matters', 'close', 'all', 'Close any matter'),
  ('matters.conflict_override.all', 'matters', 'conflict_override', 'all', 'Override an unresolved conflict flag (BR-1)'),

  -- hearings (incl. outcomes)
  ('hearings.read.own', 'hearings', 'read', 'own', 'Read own hearings'),
  ('hearings.read.team', 'hearings', 'read', 'team', 'Read team hearings'),
  ('hearings.read.all', 'hearings', 'read', 'all', 'Read all hearings (Admin excluded by shield)'),
  ('hearings.create.own', 'hearings', 'create', 'own', 'Create/record own hearings + outcomes'),
  ('hearings.create.team', 'hearings', 'create', 'team', 'Create/record team hearings + outcomes'),
  ('hearings.create.all', 'hearings', 'create', 'all', 'Create/record any hearing + outcomes'),
  ('hearings.update.own', 'hearings', 'update', 'own', 'Update own hearings'),
  ('hearings.update.team', 'hearings', 'update', 'team', 'Update team hearings'),
  ('hearings.update.all', 'hearings', 'update', 'all', 'Update any hearing'),

  -- documents
  ('documents.read.own', 'documents', 'read', 'own', 'Read own documents'),
  ('documents.read.team', 'documents', 'read', 'team', 'Read team documents'),
  ('documents.read.all', 'documents', 'read', 'all', 'Read all documents (Admin excluded by shield; Finance limited to invoices)'),
  ('documents.create.own', 'documents', 'create', 'own', 'Upload/create own documents (Client: upload-only)'),
  ('documents.create.team', 'documents', 'create', 'team', 'Upload/create team documents'),
  ('documents.create.all', 'documents', 'create', 'all', 'Upload/create any document'),
  ('documents.update.own', 'documents', 'update', 'own', 'Update own documents'),
  ('documents.update.team', 'documents', 'update', 'team', 'Update team documents'),
  ('documents.update.all', 'documents', 'update', 'all', 'Update any document'),
  ('documents.share.own', 'documents', 'share', 'own', 'Share own documents'),
  ('documents.share.team', 'documents', 'share', 'team', 'Share team documents'),
  ('documents.share.all', 'documents', 'share', 'all', 'Share any document'),

  -- privileged documents — separate module, BR-13
  ('documents_privileged.read.own', 'documents_privileged', 'read', 'own', 'Read Privileged docs on own matters (if team member)'),
  ('documents_privileged.read.team', 'documents_privileged', 'read', 'team', 'Read Privileged docs on team matters (if member)'),
  ('documents_privileged.read.all', 'documents_privileged', 'read', 'all', 'Read Privileged docs on any matter'),

  -- time entries
  ('time_entries.read.own', 'time_entries', 'read', 'own', 'Read own time entries'),
  ('time_entries.read.team', 'time_entries', 'read', 'team', 'Read team time entries'),
  ('time_entries.read.all', 'time_entries', 'read', 'all', 'Read all time entries'),
  ('time_entries.create.own', 'time_entries', 'create', 'own', 'Create own time entries'),
  ('time_entries.update.own', 'time_entries', 'update', 'own', 'Update own time entries (pre-Billed)'),
  ('time_entries.delete.own', 'time_entries', 'delete', 'own', 'Delete own time entries (pre-Billed)'),
  ('time_entries.approve.team', 'time_entries', 'approve', 'team', 'Approve/reject team time entries'),

  -- rate cards
  ('rates.manage.all', 'rates', 'manage', 'all', 'Manage rate cards'),
  ('rates.read.team', 'rates', 'read', 'team', 'Read team rate cards'),
  ('rates.read.all', 'rates', 'read', 'all', 'Read all rate cards'),

  -- invoices
  ('invoices.read.own', 'invoices', 'read', 'own', 'Read own invoices (Client: self)'),
  ('invoices.read.all', 'invoices', 'read', 'all', 'Read all invoices'),
  ('invoices.create.own', 'invoices', 'create', 'own', 'Create/update own draft invoices'),
  ('invoices.create.team', 'invoices', 'create', 'team', 'Create/update team draft invoices'),
  ('invoices.create.all', 'invoices', 'create', 'all', 'Create/update any draft invoice'),
  ('invoices.update.own', 'invoices', 'update', 'own', 'Update own draft invoices'),
  ('invoices.update.team', 'invoices', 'update', 'team', 'Update team draft invoices'),
  ('invoices.update.all', 'invoices', 'update', 'all', 'Update any draft invoice'),
  ('invoices.approve.team', 'invoices', 'approve', 'team', 'Approve team invoices'),
  ('invoices.approve.all', 'invoices', 'approve', 'all', 'Approve any invoice'),
  ('invoices.send.all', 'invoices', 'send', 'all', 'Send any invoice'),
  ('invoices.void.all', 'invoices', 'void', 'all', 'Void any invoice'),

  -- payments
  ('payments.record.all', 'payments', 'record', 'all', 'Record payments'),
  ('payments.refund.all', 'payments', 'refund', 'all', 'Issue refunds (BR-16: step-up 2FA)'),
  ('payments.read.all', 'payments', 'read', 'all', 'Read all payments'),
  ('payments.pay.own', 'payments', 'pay', 'own', 'Pay own invoices (portal pay-only)'),

  -- trust accounting
  ('trust.deposit.all', 'trust', 'deposit', 'all', 'Record trust deposits (BR-16: step-up 2FA)'),
  ('trust.disburse.all', 'trust', 'disburse', 'all', 'Record trust disbursements (BR-16: step-up 2FA, Finance: dual control)'),
  ('trust.read.all', 'trust', 'read', 'all', 'Read all trust ledgers'),

  -- tasks
  ('tasks.manage.own', 'tasks', 'manage', 'own', 'Manage own tasks'),
  ('tasks.manage.team', 'tasks', 'manage', 'team', 'Manage team tasks'),
  ('tasks.manage.all', 'tasks', 'manage', 'all', 'Manage any task'),
  ('tasks.read.all', 'tasks', 'read', 'all', 'Read all tasks'),

  -- calendar
  ('calendar.read.own', 'calendar', 'read', 'own', 'Read own calendar'),
  ('calendar.read.team', 'calendar', 'read', 'team', 'Read team calendar'),
  ('calendar.read.branch', 'calendar', 'read', 'branch', 'Read branch calendar (Reception: appointments)'),
  ('calendar.read.all', 'calendar', 'read', 'all', 'Read firm calendar'),

  -- communication
  ('comm.read.own', 'comm', 'read', 'own', 'Read own communication threads'),
  ('comm.read.team', 'comm', 'read', 'team', 'Read team communication threads'),
  ('comm.read.all', 'comm', 'read', 'all', 'Read all communication threads (Admin excluded by shield)'),
  ('comm.send.own', 'comm', 'send', 'own', 'Send communication (own) — Reception: call logging only'),
  ('comm.send.team', 'comm', 'send', 'team', 'Send communication (team)'),
  ('comm.send.all', 'comm', 'send', 'all', 'Send communication (any)'),

  -- knowledge base
  ('kb.read.all', 'kb', 'read', 'all', 'Read knowledge base'),
  ('kb.contribute.all', 'kb', 'contribute', 'all', 'Contribute knowledge base articles'),
  ('kb.review.all', 'kb', 'review', 'all', 'Review/approve knowledge base articles'),

  -- reports
  ('reports_operational.read.own', 'reports_operational', 'read', 'own', 'Run operational reports (own)'),
  ('reports_operational.read.team', 'reports_operational', 'read', 'team', 'Run operational reports (team)'),
  ('reports_operational.read.all', 'reports_operational', 'read', 'all', 'Run operational reports (firm-wide)'),
  ('reports_financial.read.team', 'reports_financial', 'read', 'team', 'Run financial reports (team)'),
  ('reports_financial.read.all', 'reports_financial', 'read', 'all', 'Run financial reports (firm-wide)'),

  -- users & roles administration
  ('users.manage.all', 'users', 'manage', 'all', 'Manage users and roles'),
  ('users.read.all', 'users', 'read', 'all', 'Read users and roles'),

  -- settings
  ('settings.manage.all', 'settings', 'manage', 'all', 'Manage firm settings (Finance: taxes/gateways only)'),
  ('settings.read.all', 'settings', 'read', 'all', 'Read firm settings'),

  -- audit
  ('audit.read.own', 'audit', 'read', 'own', 'Read a restricted subset of audit logs (Finance: financial events; HR: login events)'),
  ('audit.read.all', 'audit', 'read', 'all', 'Read all audit logs'),

  -- export
  ('export.data.own', 'export', 'data', 'own', 'Export own data (Client: self)'),
  ('export.data.team', 'export', 'data', 'team', 'Export team data'),
  ('export.data.all', 'export', 'data', 'all', 'Export firm-wide data (audited)')
) AS v(key, module, action, scope, label);
