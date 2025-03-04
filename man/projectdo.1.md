---
title: projectdo
section: 1
header: User Manual
footer: projectdo 0.2.2
date: April 24, 2024
---

# NAME

projectdo - build, run, test and more with ease

# SYNOPSIS

**projectdo** [*OPTION*] [*ACTIONS*]...

# DESCRIPTION

projectdo is a command-line program hat executes project actions (such as build,  
run, test, etc.) with the appropriate tool for current project in the working  
directory. The appropriate tool and the current project root is intelligently  
detected based on the context where projectdo is executed. For instance, projectdo  
test runs cargo test if a Cargo.toml is found and npm test if a package.json file  
is found.

# OPTIONS

**-h, `--`help**
: display help message

**-n, -d, `--`dry-run**
: do not execute any commands with side-effects

**-q, `--`quiet**
: do not print commands as they are about to be executed

**-v, `--`version**
: prints installed projectdo version.

# ACTIONS

**build**
: build project in working directory

**run**
: run the project in working directory

**test**
: test the project in working directory

**tool**
: Invoke the guessed tool for the current project

# TOOL ARGUMENTS

Any arguments following [action] are passed along to the invoked tool.

# SHELL INTEGRATION

## FISH

projectdo ships with a plugin for the Fish shell. The plugin includes  
auto-completion and functions for use with Fish's abbreviation feature.

The Fish plugin can be installed manually or with Fisher (fish plugin manager):  
`fisher install paldepind/projectdo`

The plugin exposes four shell functions that should be configured with  
abbreviations as desired. For instance:  

```
abbr -a b --function projectdo_build
abbr -a r --function projectdo_run
abbr -a t --function projectdo_test
abbr -a p --function projectdo_tool
```

With the above `t` will expand to `cargo test`, `p` will expand to `cargo`, etc.  
depending on the project.

## BASH + OTHERS

projectdo can be configured with shell aliases in any shell. For instance:  

```
alias t='projectdo test'
alias r='projectdo run'
alias b='projectdo build'
alias p='projectdo tool'
```

# SUPPORTED TOOLS AND LANGUAGES

| Tool         | Language         | Detected by                           | Commands                                    |
|--------------|------------------|---------------------------------------|---------------------------------------------|

| Cargo        | Rust             | `Cargo.toml`                          | `cargo build`, `cargo run`, `cargo test`    |
|--------------|------------------|---------------------------------------|---------------------------------------------|

| Poetry       | Python           | `pyproject.toml`                      | `poetry build`, `poetry run pytest`         |
|--------------|------------------|---------------------------------------|---------------------------------------------|

| CMake        | C, C++ and Obj-C | `CMakeLists.txt`                      | `cmake --build . --target test`             |
|--------------|------------------|---------------------------------------|---------------------------------------------|

| Meson        | C, C++, etc.     | `meson.build`                         | `meson compile`, `meson test`               |
|--------------|------------------|---------------------------------------|---------------------------------------------|

| npm          | JavaScript, etc. | `package.json`                        | `npm build`, `npm start`, `npm test`        |
|--------------|------------------|---------------------------------------|---------------------------------------------|

| yarn         | JavaScript, etc. | `package.json`, `yarn.lock`           | `yarn build`, `yarn start`, `yarn test`     |
|--------------|------------------|---------------------------------------|---------------------------------------------|

| Maven        | Java, etc.       | `pom.xml`                             | `mvn compile`, `mvn test`                   |
|--------------|------------------|---------------------------------------|---------------------------------------------|

| Leiningen    | Clojure          | `project.clj`                         | `lein test`                                 |
|--------------|------------------|---------------------------------------|---------------------------------------------|

| Cabal        | Haskell          | `*.cabal`                             | `cabal build`, `cabal run`, `cabal test`    |
|--------------|------------------|---------------------------------------|---------------------------------------------|

| Stack        | Haskell          | `stack.yaml`                          | `stack build`, `stack run`, `stack test`    |
|--------------|------------------|---------------------------------------|---------------------------------------------|

| just         | Any              | `justfile`                            | `just build`, `just run`, `just test`       |
|--------------|------------------|---------------------------------------|---------------------------------------------|

| make         | Any              | `Makefile`                            | `make`, `make test/check`                   |
|--------------|------------------|---------------------------------------|---------------------------------------------|

| Mage         | Go               | `magefile.go + test/check target`     | `mage test/check`                           |
|--------------|------------------|---------------------------------------|---------------------------------------------|

| Go           | Go               | `go.mod`                              | `go test`                                   |
|--------------|------------------|---------------------------------------|---------------------------------------------|

| Tectonic     | LaTeX            | `Tectonic.toml`                       | `tectonic -X build`                         |
|--------------|------------------|---------------------------------------|---------------------------------------------|

| .NET         | C# and F#        | `*.csproj`, `*.fsproj` or `*.sln`     | `dotnet build`, `dotnet run`, `dotnet test` |
|--------------|------------------|---------------------------------------|---------------------------------------------|

| Shell script | Any              | `build.sh`                            | `sh -c build.sh`                            |
|--------------|------------------|---------------------------------------|---------------------------------------------|

# AUTHOR

Written by `K_Lar`.

# REPORTING BUGS

Report any bugs you might find here: <https://github.com/paldepind/projectdo/issues>
