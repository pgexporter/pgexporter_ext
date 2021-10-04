CREATE FUNCTION pgexporter_used_space(text) RETURNS bigint
AS '$libdir/pgexporter_ext'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION pgexporter_free_space(text) RETURNS bigint
AS '$libdir/pgexporter_ext'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION pgexporter_total_space(text) RETURNS bigint
AS '$libdir/pgexporter_ext'
LANGUAGE C IMMUTABLE STRICT;
