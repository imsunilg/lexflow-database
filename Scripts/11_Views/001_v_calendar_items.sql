-- PROMPT DB-12. PRD Module 6 (Calendar) Database Tables: "calendar_events
-- (native events; hearings/tasks/deadlines projected via view
-- v_calendar_items union)." Unifies four native sources into one common
-- shape so the calendar grid can render everything through a single query,
-- while each source module (Hearings, Matter Important Dates, Tasks)
-- remains the system of record and is edited only at the source — per
-- Module 6 validation rule: "drag-reschedule of hearings forbidden
-- (hearings change only via hearing module) — calendar shows them locked."
-- is_locked = true for hearings backs that rule directly; every other
-- source stays editable from the calendar.
--
-- Lives in ops (same schema as calendar_events, the native-event table it
-- sits alongside) even though it reads across ops/legal.
CREATE VIEW ops.v_calendar_items AS
SELECT
  ce.id,
  ce.tenant_id,
  'Event'::text AS item_kind,
  ce.title,
  ce.starts_at,
  ce.ends_at,
  ce.all_day,
  ce.matter_id,
  ce.location,
  NULL::text AS status,
  false AS is_locked
FROM ops.calendar_events ce
WHERE ce.is_deleted = false

UNION ALL

SELECT
  h.id,
  h.tenant_id,
  'Hearing'::text AS item_kind,
  h.purpose AS title,
  (h.date + COALESCE(h.time, '00:00:00'::time))::timestamptz AS starts_at,
  NULL::timestamptz AS ends_at,
  false AS all_day,
  cc.matter_id,
  h.courtroom AS location,
  h.status,
  true AS is_locked
FROM legal.hearings h
JOIN legal.court_cases cc ON cc.id = h.case_id
WHERE h.is_deleted = false

UNION ALL

SELECT
  mid.id,
  mid.tenant_id,
  'Deadline'::text AS item_kind,
  mid.title,
  mid.due_at AS starts_at,
  NULL::timestamptz AS ends_at,
  false AS all_day,
  mid.matter_id,
  NULL::text AS location,
  CASE WHEN mid.satisfied_at IS NOT NULL THEN 'Satisfied' ELSE 'Pending' END AS status,
  false AS is_locked
FROM legal.matter_important_dates mid
WHERE mid.is_deleted = false

UNION ALL

SELECT
  t.id,
  t.tenant_id,
  'Task'::text AS item_kind,
  t.title,
  t.due_at AS starts_at,
  NULL::timestamptz AS ends_at,
  false AS all_day,
  t.matter_id,
  NULL::text AS location,
  t.status,
  false AS is_locked
FROM ops.tasks t
WHERE t.is_deleted = false AND t.due_at IS NOT NULL;
