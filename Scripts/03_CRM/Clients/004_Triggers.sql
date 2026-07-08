-- Defense-in-depth guard (PRD Module 3 AC-C4 / Error Handling: "delete with
-- dependencies → 409 listing blockers"; the app enforces the 409 with detail,
-- this trigger is the hard backstop against any path that bypasses the app).
-- legal.matters doesn't exist yet at this point in the Build Playbook (04_Legal
-- is built after 03_CRM) — to_regclass() lets this trigger no-op safely until
-- then and start enforcing automatically the moment legal.matters is created,
-- with no need to redeploy this trigger later.
CREATE OR REPLACE FUNCTION crm.trg_clients_block_delete_with_matters() RETURNS trigger AS $$
DECLARE
  v_matter_count bigint;
BEGIN
  IF to_regclass('legal.matters') IS NOT NULL THEN
    SELECT count(*) INTO v_matter_count
    FROM legal.matters
    WHERE client_id = OLD.id AND is_deleted = false;

    IF v_matter_count > 0 THEN
      RAISE EXCEPTION 'Cannot delete client % — % matter(s) still reference it (PRD Module 3 AC-C4)', OLD.id, v_matter_count;
    END IF;
  END IF;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_clients_block_delete_with_matters
  BEFORE DELETE ON crm.clients
  FOR EACH ROW
  EXECUTE FUNCTION crm.trg_clients_block_delete_with_matters();
