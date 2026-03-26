CREATE FUNCTION pgexporter_ext_log_debug5() RETURNS int
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

CREATE FUNCTION pgexporter_ext_log_debug4() RETURNS int
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

CREATE FUNCTION pgexporter_ext_log_debug3() RETURNS int
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

CREATE FUNCTION pgexporter_ext_log_debug2() RETURNS int
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

CREATE FUNCTION pgexporter_ext_log_debug1() RETURNS int
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

CREATE FUNCTION pgexporter_ext_log_info() RETURNS int
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

CREATE FUNCTION pgexporter_ext_log_notice() RETURNS int
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

CREATE FUNCTION pgexporter_ext_log_warning() RETURNS int
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

CREATE FUNCTION pgexporter_ext_log_error() RETURNS int
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

CREATE FUNCTION pgexporter_ext_log_log() RETURNS int
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

CREATE FUNCTION pgexporter_ext_log_fatal() RETURNS int
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

CREATE FUNCTION pgexporter_ext_log_panic() RETURNS int
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_ext_log_debug5() FROM PUBLIC;
REVOKE ALL ON FUNCTION pgexporter_ext_log_debug4() FROM PUBLIC;
REVOKE ALL ON FUNCTION pgexporter_ext_log_debug3() FROM PUBLIC;
REVOKE ALL ON FUNCTION pgexporter_ext_log_debug2() FROM PUBLIC;
REVOKE ALL ON FUNCTION pgexporter_ext_log_debug1() FROM PUBLIC;
REVOKE ALL ON FUNCTION pgexporter_ext_log_info() FROM PUBLIC;
REVOKE ALL ON FUNCTION pgexporter_ext_log_notice() FROM PUBLIC;
REVOKE ALL ON FUNCTION pgexporter_ext_log_warning() FROM PUBLIC;
REVOKE ALL ON FUNCTION pgexporter_ext_log_error() FROM PUBLIC;
REVOKE ALL ON FUNCTION pgexporter_ext_log_log() FROM PUBLIC;
REVOKE ALL ON FUNCTION pgexporter_ext_log_fatal() FROM PUBLIC;
REVOKE ALL ON FUNCTION pgexporter_ext_log_panic() FROM PUBLIC;

GRANT EXECUTE ON FUNCTION pgexporter_ext_log_debug5() TO pg_monitor;
GRANT EXECUTE ON FUNCTION pgexporter_ext_log_debug4() TO pg_monitor;
GRANT EXECUTE ON FUNCTION pgexporter_ext_log_debug3() TO pg_monitor;
GRANT EXECUTE ON FUNCTION pgexporter_ext_log_debug2() TO pg_monitor;
GRANT EXECUTE ON FUNCTION pgexporter_ext_log_debug1() TO pg_monitor;
GRANT EXECUTE ON FUNCTION pgexporter_ext_log_info() TO pg_monitor;
GRANT EXECUTE ON FUNCTION pgexporter_ext_log_notice() TO pg_monitor;
GRANT EXECUTE ON FUNCTION pgexporter_ext_log_warning() TO pg_monitor;
GRANT EXECUTE ON FUNCTION pgexporter_ext_log_error() TO pg_monitor;
GRANT EXECUTE ON FUNCTION pgexporter_ext_log_log() TO pg_monitor;
GRANT EXECUTE ON FUNCTION pgexporter_ext_log_fatal() TO pg_monitor;
GRANT EXECUTE ON FUNCTION pgexporter_ext_log_panic() TO pg_monitor;
