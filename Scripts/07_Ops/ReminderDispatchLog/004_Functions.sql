-- Explicit prompt requirement: "a helper function to create the next
-- month's partition (used later by a scheduled job)". Idempotent (IF NOT
-- EXISTS) so a scheduled job can call it monthly without checking first —
-- e.g. `SELECT ops.fn_create_reminder_dispatch_log_partition(current_date + interval '1 month');`
-- run on the 1st of every month.
CREATE OR REPLACE FUNCTION ops.fn_create_reminder_dispatch_log_partition(p_month date) RETURNS void AS $$
DECLARE
  v_start date := date_trunc('month', p_month)::date;
  v_end date := (date_trunc('month', p_month) + interval '1 month')::date;
  v_partition_name text := format('reminder_dispatch_log_%s', to_char(v_start, 'YYYY_MM'));
BEGIN
  EXECUTE format(
    'CREATE TABLE IF NOT EXISTS ops.%I PARTITION OF ops.reminder_dispatch_log FOR VALUES FROM (%L) TO (%L)',
    v_partition_name, v_start, v_end
  );
END;
$$ LANGUAGE plpgsql;
