#!/bin/sh

# Colors
RED=`tput setaf 1`
BOLD=`tput bold`
RESET=`tput sgr0`

ANY_ERRORS=false

# Make sets this variable when we run it and can influence the test results.
# Since this script is run through `make`, we need to unset it.
unset MAKELEVEL

# Get the directory of the current script, in a POSIX compatible way
# https://stackoverflow.com/a/29835459
script_directory=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)

# Set this variable to ensure top level Makefile doesn't affect the results.
export PROJECT_ROOT="${script_directory}/tests"

describe() {
  printf "\n$BOLD$1$RESET"
}

it() {
  printf "\n  $1"
}

assert() {
  if [ $RUN_EXIT -eq 0 ]; then
    printf " ✓"
  else
    printf "\n    Fail\n"
    ANY_ERRORS=true
  fi
}

assertEqual() {
  if [ "$1" = "$2" ]; then
    printf " ✓"
  else
    printf "\n   $BOLD$RED Error:$RESET Expected \"$1\" to equal \"$2\"\n"
    ANY_ERRORS=true
  fi
}

RUN_RESULT=""
RUN_EXIT=0

run_in() {
  RUN_RESULT=$(cd tests/$1 && ../../t -n)
  RUN_EXIT=$?
}

if describe "nodejs"; then
  if it "uses npm if package.json with test script"; then
    run_in "npm"; assert
    assertEqual "$RUN_RESULT" "npm test"
  fi
  if it "uses yarn file if yarn.lock is present"; then
    run_in "yarn"; assert
    assertEqual "$RUN_RESULT" "yarn test"
  fi
  if it "does not use npm if package.json contains no test script"; then
    run_in "npm-without-test"; assert
    assertEqual "$RUN_RESULT" "make test"
  fi
fi

if describe "make"; then
  if it "finds check target"; then
    run_in "make-check"; assert
    assertEqual "$RUN_RESULT" "make check"
  fi
fi

if describe "go"; then
  if it "finds check target in magefile"; then
    run_in "mage"; assert
    assertEqual "$RUN_RESULT" "mage check"
  fi
fi

if describe "python"; then
  if it "runs pytest with poetry"; then
    run_in "poetry"; assert
    assertEqual "$RUN_RESULT" "poetry run pytest"
  fi
fi

echo ""

if [ $ANY_ERRORS = true ]; then
  exit 1
fi
