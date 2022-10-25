CREATE FUNCTION pgexporter_version() RETURNS text
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

REVOKE ALL ON FUNCTION pgexporter_version FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgexporter_version TO pg_monitor;

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
