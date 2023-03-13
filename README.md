[![Build Status](https://travis-ci.com/paldepind/tst.svg?branch=master)](https://travis-ci.com/paldepind/tst)

# `projectdo`

Universal project commands that invoke the appropriate tool in any project.

Commbined with shell aliases `projectdo` makes it easier to build, run, and
test from the command line.

```sh
../any-project> b
# runs `cargo build` in a Rust project, `npm build` in a NodeJS project, etc.
../any-project> r
# runs `cargo run` in a Rust project, `npm start` in a NodeJS project, etc.
../any-project> t
# runs `cargo test` in a Rust project, `npm test` in a NodeJS project, etc.
```

## What

`projectdo` is a portable shell script that automatically detects the
appropriate build, run, and test command to perform in the nearest project root
relative to where it is executed. For instance, it detects a Rust project based
on the presence of a `Cargo.toml` file and then runs `cargo build/run/test`,
etc.

By combining `projectdo` with shell aliases you can swiftly build, run, and
test in any project by typing only <kbd>b</kbd>+<kbd>enter</kbd>,
<kbd>r</kbd>+<kbd>enter</kbd>, <kbd>t</kbd>+<kbd>enter</kbd>. Treat it as a
key-stroke saving short-cut that always expands to the command you want to
write.

## Features

* Implemented as a dependency free portable POSIX shell script that works on
  Linux, macOS, WSL, etc.
* Provides helpful error messages in case command are not available or cannot
  be run.
* Works with many different programming languages and project configurations.
  [See the entire list here](#supported-tools-and-languages).
* Supports 10+ tools accross many different programming languages.
* Easy to extend with support for new tools.

## Install

### From source

Download the script and place it somewhere in your path. For instance:

```
curl https://raw.githubusercontent.com/paldepind/projectdo/master/projectdo -o ~/bin/projectdo
chmod +x ~/bin/projectdo
```

If `~/bin` is in your path you can now run `projectdo`.

<!-- ### npm -->

<!-- T For Test can be installed from npm (easy if you're already using npm). -->

<!-- ``` -->
<!-- npm i --global @paldepind/tst -->
<!-- ``` -->

<!-- This automatically adds `t` to your path. -->

## Shell configuration

It is recommended that you set up shell aliases. Here are some ideas:

```sh
alias t='projectdo test'
alias r='projectdo run'
alias b='projectdo build'
```

## Usage

**Note**: When executed with the `-d` flag `projectdo` performs a dry run and
only prints information about what it would do without actually doing anything.
It is a good idea to do a dry run when using `projectdo` in a project for the
first time to verify that it does the right thing.

```
Usage: projectdo [options] [action]
Options:
  -h, --help             Display this help.
  -n, -d, --dry-run      Do not execute any commands with side-effects.
  -q, --quiet            Do not print commands as they are about to be executed.
  -v, --version          Display the version of the program.

Actions:
  build, run, test       Build, run, or test the current project.
  print-tool             Output the guessed tool for the current project.
```

## Supported tools and languages

**Note:** If a tool you are interested in is not supported please open an issue or a pull
request.

| Tool      | Language         | Detected by                                | Commands                                               |
|-----------|------------------|--------------------------------------------|--------------------------------------------------------|
| Cargo     | Rust             | `Cargo.toml`                               | `cargo build` <br/> `cargo run` <br/> `cargo test`     |
| Poetry    | Python           | `pyproject.toml` with `[tool.poetry]`      | `poetry build` <br/> run n/a <br/> `poetry run pytest` |
| CMake     | C/C++/Obj-C      | `CMakeLists.txt`                           | `cmake --build . --target test`                        |
| npm       | JavaScript, etc. | `package.json`                             | `npm build` <br/> `npm start` <br/> `npm test`         |
| yarn      | JavaScript, etc. | `package.json` and `yarn.lock`             | `yarn build` <br/> `yarn start` <br/> `yarn test`      |
| Maven     | Java, etc.       | `pom.xml`                                  | `mvn compile` <br/> run n/a <br/> `mvn test`           |
| Leiningen | Clojure          | `project.clj`                              | `lein test`                                            |
| Stack     | Haskell          | `stack.yaml`                               | `stack build` <br/> `stack run` <br/> `stack test`     |
| make      | Any              | `Makefile` with a `test`/`check` target    | `make test/check`                                      |
| Mage      | Go               | `magefile.go` with a `test`/`check` target | `mage test/check`                                      |
| Go        | Go               | `go.mod`                                   | `go test`                                              |

