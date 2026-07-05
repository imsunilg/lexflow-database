# 15_RLS_Policies

Row-Level Security enablement and tenant-isolation policies, one script per schema
(001_Core_RLS.sql, 002_CRM_RLS.sql, ... 009_KB_RLS.sql), enabling and FORCE-ing RLS
so tenant_id = current_setting('app.tenant_id')::uuid is enforced for every
tenant-scoped table. Populated in Phase B (PROMPT DB-11). Empty for now.
