CREATE FUNCTION pgexporter_information_ext() RETURNS text
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_information_ext FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_information_ext TO pg_monitor;

CREATE FUNCTION pgexporter_version_ext() RETURNS text
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_version_ext FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_version_ext TO pg_monitor;

CREATE FUNCTION pgexporter_is_supported(IN fname text) RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_is_supported FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_is_supported TO pg_monitor;

CREATE FUNCTION pgexporter_get_functions(OUT fname text, OUT has_input bool, OUT description text, OUT ftype text)
RETURNS SETOF record
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_get_functions FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_get_functions TO pg_monitor;

CREATE FUNCTION pgexporter_os_info(OUT name text,
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

REVOKE ALL ON FUNCTION pgexporter_os_info FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_os_info TO pg_monitor;

CREATE FUNCTION pgexporter_cpu_info(OUT vendor text,
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

REVOKE ALL ON FUNCTION pgexporter_cpu_info FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_cpu_info TO pg_monitor;

CREATE FUNCTION pgexporter_memory_info(OUT total_memory int8,
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

REVOKE ALL ON FUNCTION pgexporter_memory_info FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_memory_info TO pg_monitor;

CREATE FUNCTION pgexporter_load_avg(OUT load_avg_one_minute float4,
                                    OUT load_avg_five_minutes float4,
                                    OUT load_avg_ten_minutes float4
)
RETURNS SETOF record
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_load_avg FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_load_avg TO pg_monitor;

CREATE FUNCTION pgexporter_network_info(OUT interface_name text,
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

REVOKE ALL ON FUNCTION pgexporter_network_info FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_network_info TO pg_monitor;
