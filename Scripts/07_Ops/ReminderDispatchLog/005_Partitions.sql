-- Bootstrap: the parent table has zero partitions until at least one
-- exists, so create this month's and next month's now — every month
-- thereafter, the scheduled job mentioned in 004_Functions.sql creates the
-- following month's partition ahead of time.
SELECT ops.fn_create_reminder_dispatch_log_partition(current_date);
SELECT ops.fn_create_reminder_dispatch_log_partition((current_date + interval '1 month')::date);
