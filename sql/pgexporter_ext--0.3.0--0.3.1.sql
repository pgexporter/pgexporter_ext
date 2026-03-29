CREATE FUNCTION pgexporter_ext_fips() RETURNS boolean
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_ext_fips() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_ext_fips() TO pg_monitor;
