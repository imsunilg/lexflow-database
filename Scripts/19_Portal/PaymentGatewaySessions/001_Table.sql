-- Module 17 "Pay Now" (PRD Pay-Now sequence diagram, lines 1125-1139) + edge case: "invoice
-- paid at bank same day as gateway (double-payment guard: gateway session voided when
-- invoice fully allocated; race -> auto-refund flow + alert)." Lives in the portal schema
-- (not fin) since it is a portal-initiated checkout-session concept, not an accounting
-- record itself — fin.payments/fin.payment_allocations (already built, Module 8) remain the
-- system of record for money actually received; this table only tracks the client-facing
-- checkout attempt so the return-URL handler can reconcile idempotently and race-safely.
CREATE TABLE portal.payment_gateway_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  invoice_id uuid NOT NULL,
  client_portal_user_id uuid,
  gateway text NOT NULL,
  gateway_ref text,
  amount numeric(14, 2) NOT NULL,
  status text NOT NULL DEFAULT 'Created',
  idempotency_key uuid NOT NULL DEFAULT gen_random_uuid(),
  return_url text,
  created_at timestamptz NOT NULL DEFAULT now(),
  completed_at timestamptz,
  CONSTRAINT fk_payment_gateway_sessions_invoice FOREIGN KEY (invoice_id) REFERENCES fin.invoices (id),
  CONSTRAINT fk_payment_gateway_sessions_client_portal_user FOREIGN KEY (client_portal_user_id) REFERENCES crm.client_portal_users (id),
  CONSTRAINT ck_payment_gateway_sessions_status CHECK (status IN ('Created', 'Pending', 'Captured', 'Voided', 'Refunded'))
);
