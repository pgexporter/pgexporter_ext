# Getting started with pgexporter_ext

First of all, make sure that `pgexporter_ext` is installed by
using

```
ls `pg_config --libdir`/pgexporter_ext*
```

You should see

```
/path/to/postgresql/lib/pgexporter_ext.so  /path/to/postgresql/lib/pgexporter_ext.so.0.1.2
```

If you don't have `pgexporter_ext` installed see [README](../README.md) on how to
compile and install `pgexporter_ext` in your system.

## Configuration

The `postgresql.conf` must enable the extension as

```
shared_preload_libraries = 'pgexporter_ext'
```

First, activate the extension in the `postgres` database,

```
psql postgres
CREATE EXTENSION pgexporter_ext;
```

The `pgexporter` user must have access to the following functions,

```
GRANT EXECUTE ON FUNCTION pgexporter_used_space TO pgexporter;
GRANT EXECUTE ON FUNCTION pgexporter_free_space TO pgexporter;
GRANT EXECUTE ON FUNCTION pgexporter_total_space TO pgexporter;
```

[pgexporter](https://github.com/pgexporter/pgexporter) is now able to use the extended functionality
of [pgexporter_ext](https://github.com/pgexporter/pgexporter_ext).

## Closing

The [pgexporter](https://github.com/pgexporter/pgexporter_ext) community hopes that you find
the project interesting.

Feel free to

* [Ask a question](https://github.com/pgexporter/pgexporter_ext/discussions)
* [Raise an issue](https://github.com/pgexporter/pgexporter_ext/issues)
* [Submit a feature request](https://github.com/pgexporter/pgexporter_ext/issues)
* [Write a code submission](https://github.com/pgexporter/pgexporter_ext/pulls)

All contributions are most welcome !

Please, consult our [Code of Conduct](../CODE_OF_CONDUCT.md) policies for interacting in our
community.

Consider giving the project a [star](https://github.com/pgexporter/pgexporter_ext/stargazers) on
[GitHub](https://github.com/pgexporter/pgexporter_ext/) if you find it useful.
