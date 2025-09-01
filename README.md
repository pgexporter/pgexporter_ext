# pgexporter_ext

`pgexporter_ext` is an extension for [PostgreSQL](https://www.postgresql.org) to provide additional
[Prometheus](https://prometheus.io/) metrics for [pgexporter](https://pgexporter.github.io).

## Features

* OS information
* CPU information
* Memory information
* Network information
* Load average metrics
* Disk space metrics

See [Getting Started](./doc/GETTING_STARTED.md) on how to get started with `pgexporter_ext`.

## Tested platforms

* [PostgreSQL](https://www.postgresql.org/) 13+
* [Fedora](https://getfedora.org/) 32+
* [RHEL](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux) 8.x with
  [AppStream](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/installing_managing_and_removing_user-space_components/using-appstream_using-appstream)

## Compiling the source

`pgexporter` requires

* [gcc 8+](https://gcc.gnu.org) (C17)
* [cmake](https://cmake.org)
* [make](https://www.gnu.org/software/make/)
* [PostgreSQL](https://www.postgresql.org/)

```sh
dnf install git gcc cmake make postgresql-devel zlib zlib-devel libzstd libzstd-devel lz4 lz4-devel bzip2 bzip2-devel libpq-devel libpq

**NOTE**: It may happen that build fails due to `"postgres.h"` not being found. In that case, uninstall the package `postgresql-devel` and instead install `postgresql-server-devel`:

```sh
dnf remove postgresql-devel
dnf install postgresql-server-devel
```

### Release build

The following commands will install `pgexporter` in the `/usr/local` hierarchy.

```sh
git clone https://github.com/pgexporter/pgexporter_ext.git
cd pgexporter_ext
mkdir build
cd build
cmake -DCMAKE_C_COMPILER=gcc ..
make
sudo make install
```

### Debug build

The following commands will create a `DEBUG` version of `pgexporter_ext`.

```sh
git clone https://github.com/pgexporter/pgexporter_ext.git
cd pgexporter_ext
mkdir build
cd build
cmake -DCMAKE_C_COMPILER=gcc -DCMAKE_BUILD_TYPE=Debug ..
make
```

## Contributing

Contributions to `pgexporter_ext` are managed on [GitHub.com](https://github.com/pgexporter/pgexporter_ext/)

* [Ask a question](https://github.com/pgexporter/pgexporter_ext/discussions)
* [Raise an issue](https://github.com/pgexporter/pgexporter_ext/issues)
* [Feature request](https://github.com/pgexporter/pgexporter_ext/issues)
* [Code submission](https://github.com/pgexporter/pgexporter_ext/pulls)

Contributions are most welcome !

Please, consult our [Code of Conduct](./CODE_OF_CONDUCT.md) policies for interacting in our
community.

Consider giving the project a [star](https://github.com/pgexporter/pgexporter_ext/stargazers) on
[GitHub](https://github.com/pgexporter/pgexporter_ext/) if you find it useful.

## License

[BSD-3-Clause](https://opensource.org/licenses/BSD-3-Clause)
