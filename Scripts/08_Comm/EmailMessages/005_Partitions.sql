SELECT comm.fn_create_email_messages_partition(current_date);
SELECT comm.fn_create_email_messages_partition((current_date + interval '1 month')::date);
