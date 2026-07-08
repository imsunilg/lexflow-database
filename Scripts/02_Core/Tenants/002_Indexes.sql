CREATE UNIQUE INDEX ux_tenants_slug ON core.tenants (slug) WHERE is_deleted = false;
