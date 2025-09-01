-- Create functions for each log level
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

-- Revoke all permissions from PUBLIC
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

-- Grant EXECUTE permission to pg_monitor role
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

-- Renamed functions

DROP FUNCTION pgexporter_ext_information;
CREATE FUNCTION pgexporter_ext_information() RETURNS text
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_ext_information FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_ext_information TO pg_monitor;

DROP FUNCTION pgexporter_ext_version;
CREATE FUNCTION pgexporter_ext_version() RETURNS text
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_ext_version FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_ext_version TO pg_monitor;

DROP FUNCTION pgexporter_is_supported;
CREATE FUNCTION pgexporter_ext_is_supported(IN fname text) RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_ext_is_supported FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_ext_is_supported TO pg_monitor;

DROP FUNCTION pgexporter_get_functions;
CREATE FUNCTION pgexporter_ext_get_functions(OUT fname text, OUT has_input bool, OUT description text, OUT ftype text)
RETURNS SETOF record
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_ext_get_functions FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_ext_get_functions TO pg_monitor;

DROP FUNCTION pgexporter_os_info;
CREATE FUNCTION pgexporter_ext_os_info(OUT name text,
                                       OUT version text,
                                       OUT architecture text,
                                       OUT host_name text,
                                       OUT domain_name text,
                                       OUT process_count int,
                                       OUT uptime_seconds int
)
RETURNS SETOF record
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_ext_os_info FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_ext_os_info TO pg_monitor;

DROP FUNCTION pgexporter_cpu_info;
CREATE FUNCTION pgexporter_ext_cpu_info(OUT vendor text,
                                        OUT model_name text,
                                        OUT number_of_cores int,
                                        OUT clock_speed_hz int8,
                                        OUT l1dcache_size int,
                                        OUT l1icache_size int,
                                        OUT l2cache_size int,
                                        OUT l3cache_size int
)
RETURNS SETOF record
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_ext_cpu_info FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_ext_cpu_info TO pg_monitor;

DROP FUNCTION pgexporter_memory_info;
CREATE FUNCTION pgexporter_ext_memory_info(OUT total_memory int8,
                                           OUT used_memory int8,
                                           OUT free_memory int8,
                                           OUT swap_total int8,
                                           OUT swap_used int8,
                                           OUT swap_free int8,
                                           OUT cache_total int8
)
RETURNS SETOF record
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_ext_memory_info FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_ext_memory_info TO pg_monitor;

DROP FUNCTION pgexporter_load_avg;
CREATE FUNCTION pgexporter_ext_load_avg(OUT load_avg_one_minute float4,
                                        OUT load_avg_five_minutes float4,
                                        OUT load_avg_ten_minutes float4
)
RETURNS SETOF record
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_ext_load_avg FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_ext_load_avg TO pg_monitor;

DROP FUNCTION pgexporter_network_info;
CREATE FUNCTION pgexporter_ext_network_info(OUT interface_name text,
                                            OUT ip_address text,
                                            OUT tx_bytes int8,
                                            OUT tx_packets int8,
                                            OUT tx_errors int8,
                                            OUT tx_dropped int8,
                                            OUT rx_bytes int8,
                                            OUT rx_packets int8,
                                            OUT rx_errors int8,
                                            OUT rx_dropped int8,
                                            OUT link_speed_mbps int
)
RETURNS SETOF record
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_ext_network_info FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_ext_network_info TO pg_monitor;

DROP FUNCTION pgexporter_used_space;
CREATE FUNCTION pgexporter_ext_used_space(IN dir text) RETURNS bigint
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_ext_used_space FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_ext_used_space TO pg_monitor;

DROP FUNCTION pgexporter_free_space;
CREATE FUNCTION pgexporter_ext_free_space(IN dir text) RETURNS bigint
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_ext_free_space FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_ext_free_space TO pg_monitor;

DROP FUNCTION pgexporter_total_space;
CREATE FUNCTION pgexporter_ext_total_space(IN dir text) RETURNS bigint
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_ext_total_space FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_ext_total_space TO pg_monitor;
