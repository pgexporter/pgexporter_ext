CREATE FUNCTION pgexporter_used_space(text) RETURNS bigint
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_used_space FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_used_space TO pg_monitor;

CREATE FUNCTION pgexporter_free_space(text) RETURNS bigint
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_free_space FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_free_space TO pg_monitor;

CREATE FUNCTION pgexporter_total_space(text) RETURNS bigint
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_total_space FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_total_space TO pg_monitor;
