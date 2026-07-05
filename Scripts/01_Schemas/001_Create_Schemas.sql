-- 01_Schemas / 001_Create_Schemas.sql
--
-- Schema namespaces for every domain in the LexFlow database. No tables yet —
-- those are created per-object in 02_Core through 10_Audit.

CREATE SCHEMA IF NOT EXISTS core;
COMMENT ON SCHEMA core IS
  'Tenancy, users, RBAC (roles/permissions), branches, teams/departments, and session/security tables.';

CREATE SCHEMA IF NOT EXISTS crm;
COMMENT ON SCHEMA crm IS
  'Lead pipeline (sources, activities, stage history) and client records (contacts, addresses, KYC, relationships, portal access).';

CREATE SCHEMA IF NOT EXISTS legal;
COMMENT ON SCHEMA legal IS
  'Matters, court cases, hearings, orders, evidence, witnesses, and other litigation records.';

CREATE SCHEMA IF NOT EXISTS dms;
COMMENT ON SCHEMA dms IS
  'Document management: folders, documents, versions, permissions, templates, and e-signature envelopes.';

CREATE SCHEMA IF NOT EXISTS fin;
COMMENT ON SCHEMA fin IS
  'Billing, invoicing, payments, trust accounting, and time tracking. Highest-risk schema for money-integrity guarantees.';

CREATE SCHEMA IF NOT EXISTS comm;
COMMENT ON SCHEMA comm IS
  'Communication channels: email, SMS, WhatsApp, call logs, and internal chat.';

CREATE SCHEMA IF NOT EXISTS kb;
COMMENT ON SCHEMA kb IS
  'Knowledge base: acts/sections, judgments, articles, collections, tags, and bookmarks.';

CREATE SCHEMA IF NOT EXISTS ops;
COMMENT ON SCHEMA ops IS
  'Operations: tasks, calendar/events, workflow rule engine, and notifications.';

CREATE SCHEMA IF NOT EXISTS audit;
COMMENT ON SCHEMA audit IS
  'Append-only audit trail of mutations across all other schemas.';
