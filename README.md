[![Build Status](https://travis-ci.com/paldepind/tst.svg?branch=master)](https://travis-ci.com/paldepind/tst)

# `t` For Test

`t` makes it easy to run tests from the command line. The single letter command
automatically runs the appropriate tests in any project.

```sh
../any-project > t
# runs `cargo test` in a Rust project
# runs `npm test` in a NodeJS project
# runs `stack test` in a Haskell project
# ... etc.
```

## What

`t` For Test is a portable shell script that automatically detects the
appropriate test command to run in the nearest project root relative to where
it is executed. For instance, it detects a Rust project based on the presence
of a `Cargo.toml` file and then runs `cargo test`, etc.

With `t` For Test you can swiftly run tests in any project by typing only
<kbd>t</kbd>+<kbd>enter</kbd>. Treat it as a key-stroke saving short-cut that
always expands to the test command you want to write.

## Features

* Implemented as a dependency free portable POSIX shell script.
* Provides helpful error messages in case tests are not available or cannot be
  run.
* Works with many different programming languages and project configurations.
  [See the entire list here](#supported-tools-and-languages).
* Easy to extend with support for new configurations.

## Install

### From source

Download the script and place it somewhere in your path. For instance:

```
curl https://raw.githubusercontent.com/paldepind/t/master/t -o ~/bin/t
chmod +x ~/bin/t
```

If `~/bin` is in your path you can now run tests with `t`.

### npm

T For Test can be installed from npm (easy if you're already using npm).

```
npm i --global @paldepind/tst
```

This automatically adds `t` to your path.

## Usage

**Note**: When executed with the `-d` flag `t` does a dry run and only prints
information about what it would do without actually doing anything. It is a
good idea to do a dry run when using `t` in a project for the first time to
verify that it does the right thing.

```
Usage: t [options]
Options:
  -h, --help             Display this help.
  -n, -d, --dry-run      Do not execute any commands with side-effects.
  -q, --quiet            Suppress all normal output. Only errors are printed to stderr.
  -v, --version          Display the version of the program (which is 0.1.0).
```

## Supported tools and languages

If a tool you are interested in is not supported please open and issue or a
pull request.

| Tool      | Language         | Detected by                                       | Command           |
|-----------|------------------|---------------------------------------------------|-------------------|
| Cargo     | Rust             | `Cargo.toml`                                      | `cargo test`      |
| npm       | JavaScript, etc. | `package.json` with `test` script                 | `npm test`        |
| yarn      | JavaScript, etc. | `package.json` with `test` script and `yarn.lock` | `yarn test`       |
| Maven     | Java, etc.       | `pom.xml`                                         | `mvn test`        |
| Leiningen | Clojure          | `project.clj`                                     | `lein test`       |
| Stack     | Haskell          | `stack.yaml`                                      | `stack test`      |
| make      | Any              | `Makefile` with a `test`/`check` target           | `make test/check` |
| Mage      | Go               | `magefile.go` with a `test`/`check` target        | `mage test/check` |
| Go        | Go               | `go.mod`                                          | `go test`         |

