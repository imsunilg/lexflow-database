-- PROMPT DB-17. PRD Module 17 (Client Portal) Security: "Complete identity separation from
-- staff (different Identity tenant + JWT audience + cookie domain)." crm.client_portal_users
-- (the portal identity row itself) was already built in 03_CRM (DB-3) alongside crm.clients,
-- per that table's own comment: "portal_sessions/portal_messages etc. are built alongside
-- their own modules later." This is that module — everything portal-specific that isn't the
-- identity row itself (sessions, login history, messaging, appointments, activity log) lives
-- in its own schema, same one-schema-per-module convention as every other module (fin, dms,
-- ops, comm, kb, audit, rpt, ai).
CREATE SCHEMA IF NOT EXISTS portal;
COMMENT ON SCHEMA portal IS 'Client Portal: sessions, login history, secure messaging, appointment requests, activity log (Module 17).';
