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

# Global mutable variables.
QUIET=false
DRY_RUN=false
PROJECT_ROOT=""

# When running the appropriate external tool this function is used which runs
# the given command while respecting $QUIET and $DRY_RUN.
execute() {
  if [ $QUIET = false ]; then
    echo $1
  fi
  if [ $DRY_RUN = false ]; then
    if [ $QUIET = false ]; then
      eval $1
    else
      eval $1 > /dev/null
    fi
  fi
}

# Every supported tool requires two functions:
#
# 1/ A `detect_foo` function that returns 0 if the `foo` tool should be used to
#   run tests.
# 2/ A `run_foo` function that executes tests using the `foo` tool.
#
# Alternatively if separating detection and running is problematic then a
# single `detect_run_foo` function is used.

# Start list of tools

# JavaScript + NodeJS

detect_nodejs() {
  if [ -e package.json ]; then
    # We found a package.json file, let's see if it contains a test script. We
    # use npm for this even though we might end up running the tests with yarn.
    if npm run | grep -q '^[[:space:]]*test$'; then
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

detect_cargo() {
  [ -e Cargo.toml ]
}

run_cargo() {
  execute "cargo test"
}

# Haskell + Stack

detect_stack() {
  [ -e package.yaml -a -e stack.yaml ]
}

run_stack() {
  execute "stack test"
}

# Maven

detect_maven() {
  [ -e pom.xml ]
}

run_maven() {
  execute "mvn test"
}

# Clojure + Leiningen

detect_lein() {
  [ -e project.clj ]
}

run_lein() {
  execute "lein test"
}

# Makefile

detect_run_makefile() {
  if [ -e Makefile ]; then
    # We found a Makefile, let's see if it contains a test target.
    if make -n test >/dev/null 2>&1; then
      execute "make test"
      exit
    elif make -n check >/dev/null 2>&1; then
      execute "make check"
      exit
    fi
  fi
  return 1
}

# End of list of tools

detect_and_run() {
  if detect_nodejs; then
    run_nodejs
    exit
  elif detect_cargo; then
    run_cargo
    exit
  elif detect_stack; then
    run_stack
    exit
  elif detect_maven; then
    run_maven
    exit
  elif detect_lein; then
    run_lein
    exit
  fi
  detect_run_makefile
}

set_project_root() {
  # Check if git exists on the system.
  if [ -x "$(command -v git)" ]; then
    # Find the root of the git repository if we are inside one.
    PROJECT_ROOT=$(git rev-parse --show-toplevel 2> /dev/null)
    if [ $? -ne 0 ]; then
      # We are not in a git repository
      PROJECT_ROOT=$HOME
    fi
  fi
}

nothing_found() {
  echo "No tests found :'("
  exit 1
}

display_version() {
  echo "$(basename "$0") version $VERSION"
}

display_help() {
  echo "Usage: $(basename "$0") [options]
Options:
  -h, --help             Display this help.
  -n, -d, --dry-run      Do not execute any commands with side-effects.
  -q, --quiet            Do not print commands as they are about to be executed.
  -v, --version          Display the version of the program (which is $VERSION)."
}

# Main execution starts here

while getopts dhnqv-: c
do
  case $c in
    d) DRY_RUN=true ;;
    h) display_help; exit 0 ;;
    n) DRY_RUN=true ;;
    q) QUIET=true ;;
    v) display_version; exit 0 ;;
    -) case $OPTARG in
         help) display_help; exit 0 ;;
         dry-run) DRY_RUN=true ;;
         quiet) QUIET=true ;;
         version) display_version; exit 0 ;;
         '' ) break ;; # "--" should terminate argument processing
         * ) echo "Illegal option --$OPTARG" >&2; exit 1 ;;
      esac ;;
    \?) exit 1 ;;
  esac
done

set_project_root

while :
do
  detect_and_run
  # If we didn't detect a tool to run in this directory we go one directory up
  # while ensuring that we don't leave the current project and don't enter the
  # home directory.
  if [ $PWD = $PROJECT_ROOT ]; then
    nothing_found
  fi
  cd ..
  if [ $PWD = $HOME ]; then
    nothing_found
  fi
done
