CREATE UNIQUE INDEX ux_rpt_dim_date_full_date ON rpt.rpt_dim_date (full_date);

CREATE INDEX ix_rpt_dim_date_year_month ON rpt.rpt_dim_date (year, month);
