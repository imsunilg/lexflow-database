-- BR / AC-U3 (PRD Module 14 Acceptance Criteria: "last Owner cannot be
-- demoted/deactivated by any path"). Blocks both a hard DELETE and a
-- soft-delete/role-change UPDATE of the last remaining 'Owner' user_roles row
-- for a tenant.
CREATE OR REPLACE FUNCTION core.trg_user_roles_protect_last_owner() RETURNS trigger AS $$
DECLARE
  v_is_owner boolean;
  v_remaining int;
BEGIN
  IF TG_OP = 'DELETE' THEN
    SELECT EXISTS (
      SELECT 1 FROM core.roles r WHERE r.id = OLD.role_id AND r.key = 'Owner'
    ) INTO v_is_owner;

    IF v_is_owner THEN
      SELECT count(*) INTO v_remaining
      FROM core.user_roles ur
      WHERE ur.role_id = OLD.role_id
        AND ur.tenant_id = OLD.tenant_id
        AND ur.is_deleted = false
        AND ur.user_id <> OLD.user_id;

      IF v_remaining < 1 THEN
        RAISE EXCEPTION 'Cannot remove the last Owner role assignment for tenant % (PRD Module 14 AC-U3)', OLD.tenant_id;
      END IF;
    END IF;

    RETURN OLD;
  ELSIF TG_OP = 'UPDATE' THEN
    IF NEW.role_id <> OLD.role_id OR (NEW.is_deleted AND NOT OLD.is_deleted) THEN
      SELECT EXISTS (
        SELECT 1 FROM core.roles r WHERE r.id = OLD.role_id AND r.key = 'Owner'
      ) INTO v_is_owner;

      IF v_is_owner THEN
        SELECT count(*) INTO v_remaining
        FROM core.user_roles ur
        WHERE ur.role_id = OLD.role_id
          AND ur.tenant_id = OLD.tenant_id
          AND ur.is_deleted = false
          AND ur.user_id <> OLD.user_id;

        IF v_remaining < 1 THEN
          RAISE EXCEPTION 'Cannot remove the last Owner role assignment for tenant % (PRD Module 14 AC-U3)', OLD.tenant_id;
        END IF;
      END IF;
    END IF;

    RETURN NEW;
  END IF;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_user_roles_protect_last_owner
  BEFORE DELETE OR UPDATE ON core.user_roles
  FOR EACH ROW
  EXECUTE FUNCTION core.trg_user_roles_protect_last_owner();
