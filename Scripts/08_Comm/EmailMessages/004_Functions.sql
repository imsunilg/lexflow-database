-- Same partition-bootstrap need as 07_Ops/ReminderDispatchLog: a
-- partitioned table has zero partitions until at least one exists, and a
-- scheduled job needs a callable, idempotent way to create the next
-- month's partition ahead of time.
CREATE OR REPLACE FUNCTION comm.fn_create_email_messages_partition(p_month date) RETURNS void AS $$
DECLARE
  v_start date := date_trunc('month', p_month)::date;
  v_end date := (date_trunc('month', p_month) + interval '1 month')::date;
  v_partition_name text := format('email_messages_%s', to_char(v_start, 'YYYY_MM'));
BEGIN
  EXECUTE format(
    'CREATE TABLE IF NOT EXISTS comm.%I PARTITION OF comm.email_messages FOR VALUES FROM (%L) TO (%L)',
    v_partition_name, v_start, v_end
  );
END;
$$ LANGUAGE plpgsql;
