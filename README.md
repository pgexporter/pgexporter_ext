# pgexporter_ext

`pgexporter_ext` is an extension for [PostgreSQL](https://www.postgresql.org) to provide additional
[Prometheus](https://prometheus.io/) metrics for [pgexporter](https://pgexporter.github.io).

## Features

* OS information
* CPU information
* Memory information
* Load average metrics
* Disk space metrics

See [Getting Started](./doc/GETTING_STARTED.md) on how to get started with `pgexporter_ext`.

## Tested platforms

* [PostgreSQL](https://www.postgresql.org/) 10+
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
dnf install git gcc cmake make postgresql-devel
```

Alternative [clang 8+](https://clang.llvm.org/) can be used.

### Release build

The following commands will install `pgexporter` in the `/usr/local` hierarchy.

```sh
git clone https://github.com/pgexporter/pgexporter_ext.git
cd pgexporter_ext
mkdir build
cd build
cmake ..
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
cmake -DCMAKE_BUILD_TYPE=Debug ..
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
