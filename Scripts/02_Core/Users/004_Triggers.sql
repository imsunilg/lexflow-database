-- Auto-updates updated_at on every UPDATE, per this prompt's explicit instruction.
-- Scoped to core.users only for now; DB-13 (13_Functions/14_Triggers_Global)
-- introduces a shared trg_set_updated_at() applied across all mutable tables
-- schema-wide — this function is named distinctly (users_set_updated_at) so it
-- won't collide with that later, more general one.
CREATE OR REPLACE FUNCTION core.users_set_updated_at() RETURNS trigger AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_set_updated_at
  BEFORE UPDATE ON core.users
  FOR EACH ROW
  EXECUTE FUNCTION core.users_set_updated_at();
