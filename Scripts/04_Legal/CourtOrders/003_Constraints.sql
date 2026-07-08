-- Module 5 validation: "order upload requires order date ≤ today".
ALTER TABLE legal.court_orders
  ADD CONSTRAINT ck_court_orders_order_date_not_future CHECK (order_date <= current_date);

ALTER TABLE legal.court_orders
  ADD CONSTRAINT fk_court_orders_case FOREIGN KEY (case_id) REFERENCES legal.court_cases (id);

-- fk_court_orders_hearing is added in 04_Legal/Hearings/003_Constraints.sql
-- instead of here — Hearings sorts alphabetically after CourtOrders.
-- document_id is not FK'd yet — see 001_Table.sql comment (dms schema not built).
