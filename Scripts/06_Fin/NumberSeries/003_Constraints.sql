ALTER TABLE fin.number_series
  ADD CONSTRAINT ck_number_series_next_seq_positive CHECK (next_seq > 0);

ALTER TABLE fin.number_series
  ADD CONSTRAINT fk_number_series_branch FOREIGN KEY (branch_id) REFERENCES core.branches (id);

-- Forward-reference FK hoisted here: Invoices sorts alphabetically before
-- NumberSeries (Build Playbook §1.1 per-object execution order), so
-- fin.number_series doesn't exist yet when Invoices' own
-- 003_Constraints.sql would otherwise run.
ALTER TABLE fin.invoices
  ADD CONSTRAINT fk_invoices_series FOREIGN KEY (series_id) REFERENCES fin.number_series (id);
