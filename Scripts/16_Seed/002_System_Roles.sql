-- PROMPT DB-14. PRD §21 (Roles & Permissions Matrix). The 10 staff roles
-- from the matrix header (Owner, Admin, Sr Partner, Partner, Lawyer,
-- Paralegal, Reception, Finance, HR, Auditor(RO)) — Client(Portal) is
-- deliberately excluded, see 001_Permissions_Catalog.sql header comment.
-- is_system = true: these are the built-in roles every tenant gets; custom
-- roles (Enterprise) are added later by tenants themselves and are never
-- is_system.
--
-- Same demo tenant id as 001_Permissions_Catalog.sql — see that file's
-- header comment for why seeding against a not-yet-created tenant row is
-- safe here (no physical FK, 008_Demo_Tenant.sql creates the row).
WITH demo AS (
  SELECT '00000000-0000-0000-0000-000000000001'::uuid AS tenant_id
)
INSERT INTO core.roles (tenant_id, key, name, is_system)
SELECT demo.tenant_id, v.key, v.name, true
FROM demo CROSS JOIN (VALUES
  ('owner', 'Owner'),
  ('admin', 'Admin'),
  ('senior_partner', 'Senior Partner'),
  ('partner', 'Partner'),
  ('lawyer', 'Lawyer'),
  ('paralegal', 'Paralegal'),
  ('receptionist', 'Receptionist'),
  ('finance', 'Finance'),
  ('hr', 'HR'),
  ('auditor', 'Auditor (Read-Only)')
) AS v(key, name);

-- role_permissions wiring, transcribed cell-by-cell from §21. Each VALUES
-- row is (role_key, permission_key); joined against the rows just inserted
-- above and against 001_Permissions_Catalog.sql by natural key, so this
-- works regardless of the generated uuids.
WITH demo AS (
  SELECT '00000000-0000-0000-0000-000000000001'::uuid AS tenant_id
),
wiring(role_key, permission_key) AS (
  VALUES
  -- Owner: effectively all-scope on everything in the matrix
  ('owner', 'leads.read.all'), ('owner', 'leads.create.all'), ('owner', 'leads.update.all'), ('owner', 'leads.convert.all'),
  ('owner', 'clients.read.all'), ('owner', 'clients.create.all'), ('owner', 'clients.update.all'),
  ('owner', 'clients_kyc.read.all'),
  ('owner', 'matters.read.all'), ('owner', 'matters.create.all'), ('owner', 'matters.update.all'), ('owner', 'matters.close.all'), ('owner', 'matters.conflict_override.all'),
  ('owner', 'hearings.read.all'), ('owner', 'hearings.create.all'), ('owner', 'hearings.update.all'),
  ('owner', 'documents.read.all'), ('owner', 'documents.create.all'), ('owner', 'documents.update.all'), ('owner', 'documents.share.all'),
  ('owner', 'documents_privileged.read.all'),
  ('owner', 'time_entries.read.all'),
  ('owner', 'rates.manage.all'),
  ('owner', 'invoices.create.all'), ('owner', 'invoices.update.all'), ('owner', 'invoices.approve.all'), ('owner', 'invoices.send.all'), ('owner', 'invoices.void.all'),
  ('owner', 'payments.record.all'), ('owner', 'payments.refund.all'),
  ('owner', 'trust.deposit.all'), ('owner', 'trust.disburse.all'),
  ('owner', 'tasks.manage.all'),
  ('owner', 'calendar.read.all'),
  ('owner', 'comm.read.all'), ('owner', 'comm.send.all'),
  ('owner', 'kb.read.all'), ('owner', 'kb.contribute.all'), ('owner', 'kb.review.all'),
  ('owner', 'reports_operational.read.all'), ('owner', 'reports_financial.read.all'),
  ('owner', 'users.manage.all'),
  ('owner', 'settings.manage.all'),
  ('owner', 'audit.read.all'),
  ('owner', 'export.data.all'),

  -- Admin: firm operations, but blocked from matter/case/document/hearing/
  -- comm CONTENT by the privileged-content shield (✗* cells in §21) and
  -- from financial control (invoices/payments/trust/rates/time/reports_financial)
  ('admin', 'leads.read.all'), ('admin', 'leads.create.all'), ('admin', 'leads.update.all'), ('admin', 'leads.convert.all'),
  ('admin', 'clients.read.all'), ('admin', 'clients.create.all'), ('admin', 'clients.update.all'),
  ('admin', 'tasks.manage.all'),
  ('admin', 'calendar.read.all'),
  ('admin', 'kb.read.all'), ('admin', 'kb.contribute.all'), ('admin', 'kb.review.all'),
  ('admin', 'reports_operational.read.all'),
  ('admin', 'users.manage.all'),
  ('admin', 'settings.manage.all'),
  ('admin', 'audit.read.all'),
  ('admin', 'export.data.all'),

  -- Senior Partner: same reach as Owner minus payments/trust/users/settings
  ('senior_partner', 'leads.read.all'), ('senior_partner', 'leads.create.all'), ('senior_partner', 'leads.update.all'), ('senior_partner', 'leads.convert.all'),
  ('senior_partner', 'clients.read.all'), ('senior_partner', 'clients.create.all'), ('senior_partner', 'clients.update.all'),
  ('senior_partner', 'clients_kyc.read.all'),
  ('senior_partner', 'matters.read.all'), ('senior_partner', 'matters.create.all'), ('senior_partner', 'matters.update.all'), ('senior_partner', 'matters.close.all'), ('senior_partner', 'matters.conflict_override.all'),
  ('senior_partner', 'hearings.read.all'), ('senior_partner', 'hearings.create.all'), ('senior_partner', 'hearings.update.all'),
  ('senior_partner', 'documents.read.all'), ('senior_partner', 'documents.create.all'), ('senior_partner', 'documents.update.all'), ('senior_partner', 'documents.share.all'),
  ('senior_partner', 'documents_privileged.read.all'),
  ('senior_partner', 'time_entries.read.team'), ('senior_partner', 'time_entries.approve.team'),
  ('senior_partner', 'rates.manage.all'),
  ('senior_partner', 'invoices.create.all'), ('senior_partner', 'invoices.update.all'), ('senior_partner', 'invoices.approve.all'), ('senior_partner', 'invoices.send.all'), ('senior_partner', 'invoices.void.all'),
  ('senior_partner', 'tasks.manage.all'),
  ('senior_partner', 'calendar.read.all'),
  ('senior_partner', 'comm.read.all'), ('senior_partner', 'comm.send.all'),
  ('senior_partner', 'kb.read.all'), ('senior_partner', 'kb.contribute.all'), ('senior_partner', 'kb.review.all'),
  ('senior_partner', 'reports_operational.read.all'), ('senior_partner', 'reports_financial.read.all'),
  ('senior_partner', 'export.data.all'),

  -- Partner: team scope across the board
  ('partner', 'leads.read.team'), ('partner', 'leads.create.team'), ('partner', 'leads.update.team'), ('partner', 'leads.convert.team'),
  ('partner', 'clients.read.team'), ('partner', 'clients.create.team'), ('partner', 'clients.update.team'),
  ('partner', 'clients_kyc.read.team'),
  ('partner', 'matters.read.team'), ('partner', 'matters.create.team'), ('partner', 'matters.update.team'), ('partner', 'matters.close.team'),
  ('partner', 'hearings.read.team'), ('partner', 'hearings.create.team'), ('partner', 'hearings.update.team'),
  ('partner', 'documents.read.team'), ('partner', 'documents.create.team'), ('partner', 'documents.update.team'), ('partner', 'documents.share.team'),
  ('partner', 'documents_privileged.read.team'),
  ('partner', 'time_entries.read.team'), ('partner', 'time_entries.approve.team'),
  ('partner', 'rates.read.team'),
  ('partner', 'invoices.create.team'), ('partner', 'invoices.update.team'), ('partner', 'invoices.approve.team'),
  ('partner', 'tasks.manage.team'),
  ('partner', 'calendar.read.team'),
  ('partner', 'comm.read.team'), ('partner', 'comm.send.team'),
  ('partner', 'kb.read.all'), ('partner', 'kb.contribute.all'), ('partner', 'kb.review.all'),
  ('partner', 'reports_operational.read.team'), ('partner', 'reports_financial.read.team'),
  ('partner', 'export.data.team'),

  -- Lawyer: own scope, full working set, no financial control/admin
  ('lawyer', 'leads.read.own'), ('lawyer', 'leads.create.own'), ('lawyer', 'leads.update.own'), ('lawyer', 'leads.convert.own'),
  ('lawyer', 'clients.read.own'), ('lawyer', 'clients.create.own'), ('lawyer', 'clients.update.own'),
  ('lawyer', 'clients_kyc.read.own'),
  ('lawyer', 'matters.read.own'), ('lawyer', 'matters.create.own'), ('lawyer', 'matters.update.own'),
  ('lawyer', 'hearings.read.own'), ('lawyer', 'hearings.create.own'), ('lawyer', 'hearings.update.own'),
  ('lawyer', 'documents.read.own'), ('lawyer', 'documents.create.own'), ('lawyer', 'documents.update.own'), ('lawyer', 'documents.share.own'),
  ('lawyer', 'documents_privileged.read.own'),
  ('lawyer', 'time_entries.read.own'), ('lawyer', 'time_entries.create.own'), ('lawyer', 'time_entries.update.own'), ('lawyer', 'time_entries.delete.own'),
  ('lawyer', 'invoices.create.own'), ('lawyer', 'invoices.update.own'),
  ('lawyer', 'tasks.manage.own'),
  ('lawyer', 'calendar.read.own'),
  ('lawyer', 'comm.read.own'), ('lawyer', 'comm.send.own'),
  ('lawyer', 'kb.read.all'), ('lawyer', 'kb.contribute.all'),
  ('lawyer', 'reports_operational.read.own'),

  -- Paralegal: team scope on read/case-work, own scope on time entries/tasks
  ('paralegal', 'leads.read.team'), ('paralegal', 'leads.create.team'), ('paralegal', 'leads.update.team'),
  ('paralegal', 'clients.read.team'), ('paralegal', 'clients.update.team'),
  ('paralegal', 'clients_kyc.read.team'),
  ('paralegal', 'matters.read.team'),
  ('paralegal', 'hearings.read.team'), ('paralegal', 'hearings.create.team'), ('paralegal', 'hearings.update.team'),
  ('paralegal', 'documents.read.team'), ('paralegal', 'documents.create.team'), ('paralegal', 'documents.update.team'), ('paralegal', 'documents.share.team'),
  ('paralegal', 'time_entries.read.own'), ('paralegal', 'time_entries.create.own'), ('paralegal', 'time_entries.update.own'), ('paralegal', 'time_entries.delete.own'),
  ('paralegal', 'tasks.manage.own'),
  ('paralegal', 'calendar.read.team'),
  ('paralegal', 'comm.read.team'), ('paralegal', 'comm.send.team'),
  ('paralegal', 'kb.read.all'), ('paralegal', 'kb.contribute.all'),

  -- Receptionist: narrow — leads intake, name-only client read, own tasks,
  -- branch calendar/appointments, call logging
  ('receptionist', 'leads.read.own'), ('receptionist', 'leads.create.branch'),
  ('receptionist', 'clients.read.own'),
  ('receptionist', 'tasks.manage.own'),
  ('receptionist', 'calendar.read.branch'),
  ('receptionist', 'comm.send.own'),

  -- Finance: billing/trust control + read access needed to justify it
  ('finance', 'clients.read.all'),
  ('finance', 'clients_kyc.read.all'),
  ('finance', 'matters.read.all'),
  ('finance', 'documents.read.own'),
  ('finance', 'time_entries.read.all'),
  ('finance', 'rates.manage.all'),
  ('finance', 'invoices.create.all'), ('finance', 'invoices.update.all'), ('finance', 'invoices.send.all'), ('finance', 'invoices.void.all'),
  ('finance', 'payments.record.all'), ('finance', 'payments.refund.all'),
  ('finance', 'trust.deposit.all'), ('finance', 'trust.disburse.all'),
  ('finance', 'tasks.manage.own'),
  ('finance', 'calendar.read.own'),
  ('finance', 'kb.read.all'),
  ('finance', 'reports_operational.read.all'), ('finance', 'reports_financial.read.all'),
  ('finance', 'settings.manage.all'),
  ('finance', 'audit.read.own'),
  ('finance', 'export.data.all'),

  -- HR: user lifecycle + own tasks/calendar + restricted (login-only) audit
  ('hr', 'tasks.manage.own'),
  ('hr', 'calendar.read.own'),
  ('hr', 'reports_operational.read.team'),
  ('hr', 'users.manage.all'),
  ('hr', 'audit.read.own'),

  -- Auditor (Read-Only): read access across nearly everything, no writes
  ('auditor', 'leads.read.all'),
  ('auditor', 'clients.read.all'), ('auditor', 'clients_kyc.read.all'),
  ('auditor', 'matters.read.all'),
  ('auditor', 'hearings.read.all'),
  ('auditor', 'documents.read.all'), ('auditor', 'documents_privileged.read.all'),
  ('auditor', 'time_entries.read.all'),
  ('auditor', 'rates.read.all'),
  ('auditor', 'invoices.read.all'),
  ('auditor', 'payments.read.all'),
  ('auditor', 'trust.read.all'),
  ('auditor', 'tasks.read.all'),
  ('auditor', 'calendar.read.all'),
  ('auditor', 'comm.read.all'),
  ('auditor', 'kb.read.all'),
  ('auditor', 'reports_operational.read.all'), ('auditor', 'reports_financial.read.all'),
  ('auditor', 'users.read.all'),
  ('auditor', 'settings.read.all'),
  ('auditor', 'audit.read.all'),
  ('auditor', 'export.data.all')
)
INSERT INTO core.role_permissions (tenant_id, role_id, permission_id)
SELECT demo.tenant_id, r.id, p.id
FROM demo
JOIN wiring w ON true
JOIN core.roles r ON r.tenant_id = demo.tenant_id AND r.key = w.role_key
JOIN core.permissions p ON p.tenant_id = demo.tenant_id AND p.key = w.permission_key;
