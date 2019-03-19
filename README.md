# tst

A universal test command for running tests with fewer key-strokes.

tst automatically finds configuration files associated with test and runs
the appropriate command to run the tests.

In a NodeJS project it runs `npm test`, in a Rust project it runs `cargo test`,
in a Haskell project it runs `stack test`, and so on.

Alias it to `t` and treat it as a key-stroke saving short-cut that always
expands to the test command you want to write.

## Features

* Works with many different programming languages and project configuration.
* A portable dependency free POSIX shell script.
* Provides helpful error messages in case tests are not available or cannot be
  run.

## Install

### npm

```
npm install --global @paldepind/tst
```

### From source

Download the script and place it somewhere in your path. For instance:

```
curl https://raw.githubusercontent.com/paldepind/tst/master/tst > ~/bin/tst
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
