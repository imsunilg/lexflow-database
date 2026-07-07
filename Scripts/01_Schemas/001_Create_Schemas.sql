-- PROMPT DB-1 (Build Playbook §Phase B). Schema-per-concern layout per PRD §14.

CREATE SCHEMA IF NOT EXISTS core;
COMMENT ON SCHEMA core IS 'Tenancy, users, auth/RBAC, branches, teams, departments, sessions.';

CREATE SCHEMA IF NOT EXISTS crm;
COMMENT ON SCHEMA crm IS 'Leads and clients: capture, qualification, conversion, client master data.';

CREATE SCHEMA IF NOT EXISTS legal;
COMMENT ON SCHEMA legal IS 'Matters, court cases, hearings, orders, evidence, witnesses.';

CREATE SCHEMA IF NOT EXISTS dms;
COMMENT ON SCHEMA dms IS 'Document management: folders, documents, versions, permissions, e-signature.';

CREATE SCHEMA IF NOT EXISTS fin;
COMMENT ON SCHEMA fin IS 'Billing, trust accounting, time tracking.';

CREATE SCHEMA IF NOT EXISTS comm;
COMMENT ON SCHEMA comm IS 'Email, SMS, WhatsApp, calls, internal chat.';

CREATE SCHEMA IF NOT EXISTS kb;
COMMENT ON SCHEMA kb IS 'Knowledge base: acts, sections, judgments, articles.';

CREATE SCHEMA IF NOT EXISTS ops;
COMMENT ON SCHEMA ops IS 'Tasks, calendar, workflow automation, notifications.';

CREATE SCHEMA IF NOT EXISTS audit;
COMMENT ON SCHEMA audit IS 'Insert-only audit trail, partitioned by month.';
