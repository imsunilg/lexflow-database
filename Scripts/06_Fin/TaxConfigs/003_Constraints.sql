ALTER TABLE fin.tax_configs
  ADD CONSTRAINT ck_tax_configs_type CHECK (tax_type IN ('GST', 'VAT', 'SalesTax', 'None'));

ALTER TABLE fin.tax_configs
  ADD CONSTRAINT fk_tax_configs_branch FOREIGN KEY (branch_id) REFERENCES core.branches (id);
