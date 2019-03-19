# tst

A single letter command that runs the tests in any code project.

```sh
any-project> t
# runs the tests in the project (npm test, cargo test, stack test, etc.)
```

## What

tst is a small shell script for running tests in any code projects. It uses
clever ~~state of the art A.I.~~ hard coded checks to automatically detect the
appropriate test command to execute in the nearest project root relative to
where it is executed.

For instance, it detects a Rust project based on the presence of a `Cargo.toml`
file and then runs `cargo test`. As another example, if it finds a
`package.json` file with a `test` script it runs `npm test`, except if a
`yarn.lock` file is also present, then it runs `yarn test`.

## Why

By aliasing `tst` to `t` you can swiftly run tests in any project by typing
only <kbd>t</kbd>+<kbd>enter</kbd>. Treat it as a key-stroke saving short-cut
that always expands to the test command you want to write.

## Features

* Implemented as a portable dependency free POSIX shell script.
* Provides helpful error messages in case tests are not available or cannot be
  run.
* Works with many different programming languages and project configurations.
  [See the entire list here](#supported-tools-and-languages).
* Support for new configurations is easy to add.

## Install

### npm

```
npm install --global @paldepind/tst
```

This adds both `t` and `tst` to your path.

### From source

Download the script and place it somewhere in your path. For instance:

```
curl https://raw.githubusercontent.com/paldepind/tst/master/tst > ~/bin/tst
```

## Usage

**Note**: When executed with the `-d` flag `tst` only prints information about
what it would do without actually doing anything. It is a good idea to do a dry
run when using `tst` in a project for the first time to verify that it does the
right thing.

```
Usage: t [options]
Options:
  -h, --help             Display this help.
  -n, -d, --dry-run      Do not execute any commands with side-effects.
  -q, --quiet            Do not print commands as they are about to be executed.
  -v, --version          Display the version of the program (which is 0.1.0).
```

## Supported tools and languages

| Tool      | Language         | Detected by                                       | Command      |
|-----------|------------------|---------------------------------------------------|--------------|
| npm       | JavaScript, etc. | `package.json` with `test` script                 | `npm test`   |
| yarn      | JavaScript, etc. | `package.json` with `test` script and `yarn.lock` | `yarn test`  |
| Cargo     | Rust             | `Cargo.toml`                                      | `cargo test` |
| Maven     | Java, etc.       | `pom.xml`                                         | `mvn test`   |
| Leiningen | Clojure          | `project.clj`                                     | `lein test`  |
| Stack     | Haskell          | `stack.yaml`                                      | `stack test` |
| make      | Any              | `Makefile` with a `test` target                   | `make test`  |
