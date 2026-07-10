-- Additive to 02_Core, added after DB-2 had already been applied (DbUp journals by
-- script name, not content hash). §34: "webhook ingress: single /api/v1/webhooks/
-- {provider} router -> signature verification -> dedupe (event id store 7 d) ->
-- outbox event." This table is the dedupe store — one row per (tenant, provider,
-- external event id) actually processed; a replayed webhook delivery hits the unique
-- constraint and is treated as an idempotent no-op by the router.
-- Lives in core (not comm) because §34 describes this as shared ingress
-- infrastructure for every provider integration (payments, signature, calendar sync,
-- comm channels), not comm-specific business data.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
CREATE TABLE core.webhook_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  provider text NOT NULL,
  event_id text NOT NULL,
  received_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_at timestamptz,
  updated_by uuid,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_at timestamptz,
  deleted_by uuid
);

ALTER TABLE core.webhook_events
  ADD CONSTRAINT uq_webhook_events_tenant_provider_event UNIQUE (tenant_id, provider, event_id);

-- The retention job's core query: "purge anything older than 7 days."
CREATE INDEX ix_webhook_events_received_at ON core.webhook_events (received_at);
