ALTER TABLE ops.workflow_runs
  ADD CONSTRAINT ck_workflow_runs_status CHECK (status IN ('Pending', 'Running', 'Succeeded', 'Failed'));

ALTER TABLE ops.workflow_runs
  ADD CONSTRAINT fk_workflow_runs_rule FOREIGN KEY (rule_id) REFERENCES ops.workflow_rules (id);
