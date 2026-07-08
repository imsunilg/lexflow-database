-- Module 10 edge case / AC-TK2: "circular refs rejected" — dependency graph
-- must stay a DAG (§19.12: "Task ↔ Task: DAG only (dependency insert runs
-- cycle check)"). Walk the dependency chain starting at the new edge's
-- depends_on_task_id: if task_id is reachable from there, the new edge
-- would close a cycle.
CREATE OR REPLACE FUNCTION ops.trg_task_dependencies_check_cycle() RETURNS trigger AS $$
DECLARE
  v_cycle boolean;
BEGIN
  WITH RECURSIVE chain AS (
    SELECT depends_on_task_id AS node
    FROM ops.task_dependencies
    WHERE task_id = NEW.depends_on_task_id

    UNION

    SELECT td.depends_on_task_id
    FROM ops.task_dependencies td
    JOIN chain c ON td.task_id = c.node
  )
  SELECT EXISTS (SELECT 1 FROM chain WHERE node = NEW.task_id) INTO v_cycle;

  IF v_cycle THEN
    RAISE EXCEPTION 'CYCLE_DETECTED: adding dependency % -> % would create a cycle', NEW.task_id, NEW.depends_on_task_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_task_dependencies_check_cycle
  BEFORE INSERT ON ops.task_dependencies
  FOR EACH ROW EXECUTE FUNCTION ops.trg_task_dependencies_check_cycle();
