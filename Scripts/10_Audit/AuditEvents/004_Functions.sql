-- Explicit prompt requirement: "a monthly-partition-creation SQL function
-- audit.fn_ensure_partition(month date) to be called by a scheduled job."
-- Idempotent (CREATE TABLE IF NOT EXISTS) so the job can call it
-- unconditionally every month. Each new partition gets the same
-- grant/revoke treatment as the parent (003_Insert_Only_Trigger.sql) —
-- BEFORE UPDATE/DELETE triggers on a partitioned parent propagate to every
-- partition automatically, but table-level GRANT/REVOKE do not, so a
-- partition queried by its own name (bypassing the parent) would otherwise
-- fall back to whatever default privileges apply. Re-applying the same
-- REVOKE/GRANT on the partition here closes that gap — defense in depth
-- all the way down to each physical partition.
CREATE OR REPLACE FUNCTION audit.fn_ensure_partition(month date) RETURNS void AS $$
DECLARE
  v_start date := date_trunc('month', month)::date;
  v_end date := (date_trunc('month', month) + interval '1 month')::date;
  v_partition_name text := format('audit_events_%s', to_char(v_start, 'YYYY_MM'));
BEGIN
  EXECUTE format(
    'CREATE TABLE IF NOT EXISTS audit.%I PARTITION OF audit.audit_events FOR VALUES FROM (%L) TO (%L)',
    v_partition_name, v_start, v_end
  );

  EXECUTE format('REVOKE UPDATE, DELETE ON audit.%I FROM PUBLIC', v_partition_name);
  EXECUTE format('REVOKE UPDATE, DELETE ON audit.%I FROM lexflow_app', v_partition_name);
  EXECUTE format('GRANT SELECT, INSERT ON audit.%I TO lexflow_app', v_partition_name);
END;
$$ LANGUAGE plpgsql;
