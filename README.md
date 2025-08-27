# Ōkura: The Great Ruby Treasury

Ōkura (大蔵), Japanese for "Treasury" (or, more literally, "great storehouse") is a tool for managing versions of Ruby built from source.

The tool is simple. I developed it while building Ruby from source and primarily as a thought experiment about package managers.

## Ōkura Usage

### Install and Set Up

Clone the Ōkura repository into `~/.okura`:

```
git clone https://github.com/elijahgreenstein/okura.git > .okura
```

Change into the `.okura` directory and use `make` to create required directories and add `~/.okura/bin` to your $PATH:

```
cd .okura
make
```

Follow the [instructions below](#ruby-installation) to build and install the RubyGems dependencies (OpenSSL, LibYAML, and zlib) and Ruby from source.

### Usage

#### Activate Environments

Activating environments is simple:

```
okura activate <env>
```

This command creates symlinks in `~/.okura/bin` to the executables in `~/.okura/envs/<env>/bin`.

Use the `-t` or `--test` options to check that Ōkura will create the correct links:

```
okura -t activate <env>
okura --test activate <env>
```

#### List Environments

Use the following command to list the name of all environments:

```
okura list
```

This lists all directories in `~/.okura/envs`.

### Uninstall

To uninstall an environment, remove its directory in `~/.okura/envs`:

```
rm -rf ~/.okura/envs/<env>
```

To uninstall Ōkura, remove the `~/.okura` directory:

```
rm -rf ~/.okura
```

## Ruby Installation

### Dependencies

As specified in the [Building Ruby][ruby-building] guide, RubyGems requires [OpenSSL][openssl-download], [LibYAML][libyaml-source], and [zlib][zlib].

The examples below reference the following versions:

- OpenSSL: 3.5.2
- LibYAML: 0.2.5
- zlib: 1.3.1

Change the version number as necessary to install a different version.

#### Download

Download tarballs for each dependency and move them into `~/.okura/pkgs`. Note the official SHA-256 hash values when provided and add them to `~/.okura/pkgs/hash256.txt` in the format `<HASH> <FILE>`. Check the SHA-256 hashes:

```
cd ~/.okura/pkgs
shasum -a 256 -c hash256.txt
```

After verifying the hashes, extract the source code:

```
for file in *.tar.gz; do
tar -xzf $file
done
```

#### Build and Install

Install each dependency into `~/.okura/local`. Use the `--prefix` option when configuring each build to specify this nonstandard location.

LibYAML:

```
cd ~/.okura/pkgs/yaml-0.2.5
./configure --prefix="$HOME/.okura/local"
make
make install
```

OpenSSL (note the additional `--openssldir` option):

```
cd ~/.okura/pkgs/openssl-3.5.2
./Configure --prefix="$HOME/.okura/local" \
  --openssldir="$HOME/.okura/local/ssl"
make
make test
make install
```

zlib:

```
cd ~/.okura/pkgs/zlib-1.3.1
./configure --prefix="$HOME/.okura/local"
make test
make install
```

#### (Optional) Clean Up

Remove the extracted source code:

```
rm -rf openssl-3.5.2 yaml-0.2.5 zlib-1.3.1
```

### Ruby

#### Download

Download a Ruby tarball from the [Ruby download page][ruby-download] or [Ruby releases page][ruby-releases] (the examples below use version 3.4.5) and move it to `~/.okura/pkgs`. Note the SHA-256 hash value and add it to `~/.okura/pkgs/hash256.txt` in the format `<HASH> ruby-3.4.5.tar.gz`. Check the hash value and then extract the source code:

```
cd ~/.okura/pkgs
shasum -a 256 -c hash256.txt
tar -xzf ruby-3.4.5.tar.gz
```

#### Build and Install

As detailed in the [Building Ruby][ruby-building] guide, make a build directory and change into it:

```
cd ruby-3.4.5
mkdir build && cd build
```

Use the `--with-opt-dir` option to specify the location of the RubyGems dependencies when configuring the build. Use the `--prefix` option to specify the installation location. Install all versions of Ruby into directories in `~/.okura/envs/<env>`. The examples below create an Ōkura environment named `main`:

```
../configure --prefix="$HOME/.okura/envs/main" \
  --with-opt-dir="$HOME/.okura/local"
```

Build, test, and install Ruby:

```
make
make test-all
make test
```

#### (Optional) Clean Up

Remove the extracted source code:

```
rm -rf ~/.okura/pkgs/ruby-3.4.5
```

#### Activate Ruby

As [detailed above](#activate-environments), use `okura activate` to activate the Ruby environment:

```
okura activate main
```

#### Add Environments

Retain the built dependencies (LibYAML, OpenSSL, and zlib) in `~/.okura/local` to simplify building additional versions of Ruby. To build a new environment with the same version of Ruby, follow the [build and install](#build-and-install-1) instructions above, but replace `main` with a different environment name. To build a different version, begin with the [download](#download-1) instructions above, but choose a different version. Then follow the [build and install](#build-and-install-1) instructions.

[libyaml-source]: https://pyyaml.org/wiki/LibYAML "LibYAML"
[openssl-download]: https://github.com/openssl/openssl/releases "OpenSSL Releases"
[ruby-building]: https://docs.ruby-lang.org/en/master/contributing/building_ruby_md.html "Building Ruby"
[ruby-download]: https://www.ruby-lang.org/en/downloads/ "Download Ruby"
[ruby-releases]: https://www.ruby-lang.org/en/downloads/releases/ "Ruby Releases"
[zlib]: https://www.zlib.net/ "zlib"
