# 06_Fin

Billing, invoicing, payments, trust accounting, and time tracking (schema: `fin`). Highest-risk schema — see PRD Module 8/9 for guardrails (invoice immutability, trust append-only ledger, etc.).

Per-object subfolders (each populated in Phase B, following the numbering rule in
LexFlow_Build_Playbook.md §1.1):

- `RateCards/`
- `RateCardEntries/`
- `BillingArrangements/`
- `Invoices/`
- `InvoiceLines/`
- `InvoiceTaxes/`
- `InvoiceStatusHistory/`
- `Payments/`
- `PaymentAllocations/`
- `CreditNotes/`
- `Refunds/`
- `DunningSchedules/`
- `DunningEvents/`
- `TrustAccounts/`
- `TrustLedgerEntries/`
- `TrustReconciliations/`
- `TrustReconciliationItems/`
- `TaxConfigs/`
- `NumberSeries/`
- `TimeEntries/`
- `RunningTimers/`
- `ActivityCodes/`

