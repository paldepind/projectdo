<div align="right">
  <a href="https://github.com/paldepind/projectdo/actions/workflows/makefile.yml">
    <img src="https://github.com/paldepind/projectdo/actions/workflows/makefile.yml/badge.svg" />
  </a>
</div>
<img src="logo.png" height="90" alt="projectdo" />

Context-aware single-letter project commands to speed up your terminal workflow.

* `b` to build/compile any project
* `r` to run/start any project
* `t` to test any project

https://user-images.githubusercontent.com/521604/231857437-12c14aff-585d-4817-8f44-59b40ecc32e0.mov

* **Supports 10+ build and project tools** – [See the entire list
  here](#supported-tools-and-languages).
* **Portable** – Dependency free portable POSIX shell script. Supports Linux,
  macOS, WSL, etc.
* **Shell Integration** – Shell integration for the Fish shell through a [Fish
  shell](#fish-plugin) plugin.
* **Simple** – Easy to extend with support for new tools.

## What

`projectdo` is a terminal program and Fish shell plugin that executes project
actions (such as build, run, test, etc.) with the _appropriate tool_ in the
_current project_. The appropriate tool and the current project root is
intelligently detected based on the context where `projectdo` is executed.

For instance, `projectdo test` tests the current project. If a `Cargo.toml` is
found then `cargo test` is executed, if a `package.json` file is found then
`npm test` is executed, and so on.

By combining `projectdo` with shell aliases or shell abbreviations project
commands can be run in any project with less typing. For instance, with the
alias `alias b='projectdo build'` one can build any project simply by typing
<kbd>b</kbd>+<kbd>enter</kbd>.

## Install

### Using Homebrew

`projectdo` can be installed with Homebrew on macOS and Linux.

```
brew install paldepind/tap/projectdo
```

### From source

Download the script and place it somewhere in your path. For instance if
`~/bin` is in your path:

```
curl https://raw.githubusercontent.com/paldepind/projectdo/master/projectdo -o ~/bin/projectdo
chmod +x ~/bin/projectdo
```

## Shell integration

For the Fish shell use [the Fish plugin](#fish-plugin). For Bash and Zsh setup
[shell aliases](#aliases).

### Fish Plugin

`projectdo` ships with a plugin for the Fish shell. The plugin includes
auto-completion and functions for use with Fish's abbreviation feature.

The Fish plugin can be installed manually or with
[Fisher](https://github.com/jorgebucaran/fisher):

```
fisher install paldepind/projectdo
```

The plugin exposes four shell functions that should be configured with
abbreviations as desired. For instance:

```
abbr -a b --function projectdo_build
abbr -a r --function projectdo_run
abbr -a t --function projectdo_test
abbr -a p --function projectdo_tool
```

With the above `t` will expand to `cargo test`, `p` will expand to `cargo`,
etc. depending on the project.

_Note that you need to have the script in your path in order for the Fish plugin to work!_

### Aliases

`projectdo` can be configured with shell aliases in any shell. For instance:

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
Usage: projectdo [options] [action] [tool-arguments]
Options:
  -h, --help             Display this help.
  -n, -d, --dry-run      Do not execute any commands with side-effects.
  -q, --quiet            Do not print commands as they are about to be executed.
  -v, --version          Display the version of the program.

Actions:
  build, run, test       Build, run, or test the current project.
  tool                   Invoke the guessed tool for the current project.

Tool arguments:
  Any arguments following [action] are passed along to the invoked tool.
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
| Cabal     | Haskell          | `*.cabal`                                  | `cabal build` <br/> `cabal run` <br/> `cabal test`     |
| Stack     | Haskell          | `stack.yaml`                               | `stack build` <br/> `stack run` <br/> `stack test`     |
| make      | Any              | `Makefile`                                 | `make` <br/> `make test/check`                         |
| Mage      | Go               | `magefile.go` with a `test`/`check` target | `mage test/check`                                      |
| Go        | Go               | `go.mod`                                   | `go test`                                              |
| Tectonic  | LaTeX            | `Tectonic.toml`                            | `tectonic -X build`                                    |

