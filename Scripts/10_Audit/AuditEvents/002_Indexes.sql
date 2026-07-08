-- CREATE INDEX on a partitioned table propagates to every existing
-- partition and to every partition created later via PARTITION OF.

-- Explicit prompt requirement / §18 critical index: "CREATE INDEX
-- ix_audit_entity ON audit.audit_events(tenant_id, entity_type, entity_id, at DESC);".
CREATE INDEX ix_audit_entity ON audit.audit_events (tenant_id, entity_type, entity_id, at DESC);

-- §30 Access: "Audit browser ... filter by entity, actor, action, date".
CREATE INDEX ix_audit_events_actor ON audit.audit_events (tenant_id, actor_user_id, at DESC);

CREATE INDEX ix_audit_events_action ON audit.audit_events (tenant_id, action, at DESC);

CREATE INDEX ix_audit_events_trace ON audit.audit_events (trace_id);
