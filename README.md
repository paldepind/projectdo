[![Build Status](https://travis-ci.com/paldepind/tst.svg?branch=master)](https://travis-ci.com/paldepind/tst)

# `projectdo`

Universal context-aware project commands that can build, run, and test any
project.

Combined with shell aliases or shell abbreviations `projectdo` makes it easy
to build, run, and test from the command line.

```sh
../any-project> b # alias for `projectdo build`
# runs `cargo build`, `npm build`, `make`, etc. depending on the project
../any-project> r # alias for `projectdo run`
# runs `cargo run`, `npm start`, etc. depending on the project
../any-project> t # alias for `projectdo test`
# runs `cargo test`, `npm test`, `make check`, etc. depending on the project
```

## What

`projectdo` is a portable shell script that automatically detects the
appropriate project/build tool in the nearest project root relative to where it
is executed. It can invoke this tool to build, run, or test the project or pass
arbitrary commands to the tool.

For instance, it detects a Rust project based on the presence of a `Cargo.toml`
file and `projectdo run` then executes `cargo run`. If, on the other hand, a
`package.json` file is present then `projectdo run` executes `npm start`.

By combining `projectdo` with shell aliases or shell abbreviations project
commands can be run in any project with less typing. For instance, with the
alias `alias b='projectdo build'` one can build any project simply by typing
<kbd>b</kbd>+<kbd>enter</kbd>. Treat it as a keystroke saving short-cut that
always expands to the command you want to write.

## Features

* **Portable** – Implemented as a dependency free portable POSIX shell script
  that works on Linux, macOS, WSL, etc.
* **Shell Integration** – Ships with shell integration for the Fish shell.
* **Helpful** – Provides helpful error messages in case command are not
  available or cannot be run.
* **Supports Many Tools** – Supports 10+ tools across many programming
  languages and project configurations. [See the entire list
  here](#supported-tools-and-languages).
* **Simple** – Easy to extend with support for new tools.

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

## Shell integration

### Fish integration

`projectdo` ships with integration for Fish. The integration includes
auto-completion and functions for use with Fish's abbreviation feature.

The Fish integration can be installed manually or with
[Fisher](https://github.com/jorgebucaran/fisher):

```
fisher install paldepind/projectdo
```

Afterwards abbreviations should be configured as desired. For instance:

```
abbr -a b --function projectdo_build
abbr -a s --function projectdo_run
abbr -a t --function projectdo_test
abbr -a p --function projectdo_tool
```

With the above `t` will expand to `cargo test`, `p` will expand to `cargo`,
etc. depending on the project.

### Aliases

`projectdo` can be configured with shell aliases. These work in any shell. For
instance:

```sh
alias t='projectdo test'
alias r='projectdo run'
alias b='projectdo build'
alias p='projectdo tool'
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
  tool                   Invoke the guessed tool for the current project."
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

