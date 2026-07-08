-- Bootstrap: the parent table has zero partitions until at least one
-- exists, so create this month's and next month's now — every month
-- thereafter, the scheduled job mentioned in 004_Functions.sql calls
-- audit.fn_ensure_partition() to create the following month's partition
-- ahead of time.
SELECT audit.fn_ensure_partition(current_date);
SELECT audit.fn_ensure_partition((current_date + interval '1 month')::date);
