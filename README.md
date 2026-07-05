
lexflow-database/
├── Scripts/
│   ├── 00_Extensions/
│   │   └── 001_Enable_Extensions.sql
│   ├── 01_Schemas/
│   │   └── 001_Create_Schemas.sql
│   ├── 02_Core/
│   │   ├── Tenants/            001_Table.sql  002_Indexes.sql  003_Constraints.sql
│   │   ├── Branches/           001_Table.sql  002_Indexes.sql
│   │   ├── Users/               001_Table.sql  002_Indexes.sql  003_Constraints.sql  004_Triggers.sql
│   │   ├── Roles/  Permissions/  RolePermissions/  UserRoles/  UserPermissionGrants/
│   │   ├── Teams/  TeamMembers/  Departments/
│   │   └── Sessions/  LoginHistory/  IpAllowlists/
│   ├── 03_CRM/
│   │   ├── LeadSources/  Leads/  LeadActivities/  LeadStageHistory/  LostReasons/
│   │   └── Clients/  ClientContacts/  ClientAddresses/  ClientIdentityDocuments/  ClientRelationships/  ClientPortalUsers/
│   ├── 04_Legal/
│   │   ├── PracticeAreas/  Matters/  MatterTeamMembers/  MatterParties/  MatterImportantDates/  MatterRelated/  MatterExpenses/
│   │   └── Courts/  Judges/  CourtCases/  Hearings/  HearingOutcomes/  CourtOrders/  CaseParties/  EvidenceItems/  EvidenceCustodyLog/  Witnesses/  ArgumentNotes/  CourtHolidays/
│   ├── 05_DMS/
│   │   ├── Folders/  Documents/  DocumentVersions/  DocumentTags/  Tags/  DocumentPermissions/  DocumentShareLinks/
│   │   └── DocumentTemplates/  TemplateMergeFields/  SignatureEnvelopes/  SignatureSigners/  DocumentActivity/
│   ├── 06_Fin/
│   │   ├── RateCards/  RateCardEntries/  BillingArrangements/
│   │   ├── Invoices/  InvoiceLines/  InvoiceTaxes/  InvoiceStatusHistory/
│   │   ├── Payments/  PaymentAllocations/  CreditNotes/  Refunds/  DunningSchedules/  DunningEvents/
│   │   ├── TrustAccounts/  TrustLedgerEntries/  TrustReconciliations/  TrustReconciliationItems/
│   │   ├── TaxConfigs/  NumberSeries/
│   │   └── TimeEntries/  RunningTimers/  ActivityCodes/
│   ├── 07_Ops/
│   │   ├── Tasks/  TaskAssignees/  TaskChecklistItems/  TaskComments/  TaskDependencies/  TaskTemplates/  TaskTemplateItems/
│   │   ├── CalendarEvents/  EventAttendees/  EventReminders/  RecurrenceExceptions/  ExternalCalendarAccounts/  ExternalEventLinks/
│   │   ├── WorkflowRules/  WorkflowRuns/
│   │   └── Notifications/  ReminderDispatchLog/
│   ├── 08_Comm/
│   │   ├── Mailboxes/  EmailThreads/  EmailMessages/  EmailAttachments/
│   │   ├── SmsMessages/  WhatsappMessages/  WhatsappOptins/  CallLogs/
│   │   └── ChatChannels/  ChatMembers/  ChatMessages/  CommTemplates/
│   ├── 09_KB/
│   │   ├── KbActs/  KbActSections/  KbJudgments/
│   │   └── KbArticles/  KbArticleVersions/  KbTags/  KbItemTags/  KbCollections/  KbCollectionItems/  KbBookmarks/  KbMatterPins/
│   ├── 10_Audit/
│   │   └── AuditEvents/         001_Table.sql (partitioned)  002_Indexes.sql  003_Insert_Only_Trigger.sql
│   ├── 11_Views/
│   ├── 12_MaterializedViews/
│   ├── 13_Functions/
│   ├── 14_Triggers_Global/
│   ├── 15_RLS_Policies/
│   ├── 16_Seed/
│   └── 17_Reporting_StarSchema/
├── Runner/
│   └── LexFlow.Database.Runner/     (DbUp console app)
└── README.md
