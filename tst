#!/bin/sh

# tst – a universal test command.
# Copyright (C) 2019-present  Simon Friis Vindum

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

VERSION="0.1.0"
QUIET=false
DRY_RUN=false

# JavaScript + NodeJS

check_nodejs() {
  if [ -e package.json ]; then
    # We found a package.json file, let's see if it contains a test command.
    if grep -q '^[[:space:]]*"test"' package.json; then
      return 0
    fi
  fi
  return 1
}

run_nodejs() {
  if [ -e yarn.lock ]; then
    execute "yarn test"
  else
    execute "npm test"
  fi
}

# Rust + Cargo

check_cargo() {
  [ -e Cargo.toml ]
}

run_cargo() {
  execute "cargo test"
}

# Haskell + Stack

check_stack() {
  [ -e package.yaml -a -e stack.yaml ]
}

run_stack() {
  execute "stack test"
}

# Maven

check_maven() {
  [ -e pom.xml ]
}

run_maven() {
  execute "mvn test"
}

# Clojure + Leiningen

check_lein() {
  [ -e project.clj ]
}

run_lein() {
  execute "lein test"
}

# Makefile

check_makefile() {
  if [ -e Makefile ]; then
    # We found a Makefile, let's see if it contains a test target.
    if grep -q '^test:' Makefile; then
      return 0
    fi
  fi
  return 1
}

run_makefile() {
  execute "make test"
}

# End of list of environments

execute() {
  if [ $QUIET = false ]; then
    echo $1
  fi
  if [ $DRY_RUN = false ]; then
    eval $1
  fi
}

check_and_run() {
  if check_nodejs; then
    run_nodejs
    exit
  elif check_cargo; then
    run_cargo
    exit
  elif check_stack; then
    run_stack
    exit
  elif check_maven; then
    run_maven
    exit
  elif check_lein; then
    run_lein
    exit
  elif check_makefile; then
    run_makefile
    exit
  fi
}

# The root of the project.
TOP=""

# Check if git exists on the system.
if [ -x "$(command -v git)" ]; then
  # Find the root of the git repository if we are inside one.
  TOP=$(git rev-parse --show-toplevel 2> /dev/null)
  if [ $? -ne 0 ]; then
    # We are not in a git repository
    TOP=$HOME
  fi
fi

nothing_found() {
  echo "No tests found :'("
  exit 1
}

main() {
  while :
  do
    check_and_run
    if [ $PWD = $TOP ]; then
      nothing_found
    fi
    cd ..
    if [ $PWD = $HOME ]; then
      nothing_found
    fi
  done
}

displayVersion() {
  echo "$(basename "$0") version $VERSION"
}

displayHelp() {
  echo "Usage: $(basename "$0") [options]
Options:
  -h, --help             Display this help.
  -n, -d, --dry-run      Do not execute any commands with side-effects.
  -q, --quiet            Do not print commands as they are about to be executed.
  -v, --version          Display the version of the program (which is $VERSION)."
}

while getopts dhnqv-: c
do
  case $c in
    d) DRY_RUN=true ;;
    h) displayHelp; exit 0 ;;
    n) DRY_RUN=true ;;
    q) QUIET=true ;;
    v) displayVersion; exit 0 ;;
    -) case $OPTARG in
         help) displayHelp; exit 0 ;;
         dry-run) DRY_RUN=true ;;
         quiet) QUIET=true ;;
         version) displayVersion; exit 0 ;;
         '' ) break ;; # "--" should terminate argument processing
         * ) echo "Illegal option --$OPTARG" >&2; exit 1 ;;
      esac ;;
    \?) exit 1 ;;
  esac
done

main
