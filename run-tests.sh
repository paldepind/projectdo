#!/bin/sh

# Colors
RED=`tput setaf 1`
BOLD=`tput bold`
RESET=`tput sgr0`

ANY_ERRORS=false

describe() {
  echo -n "\n$BOLD$1$RESET"
}

it() {
  echo -n "\n  $1"
}

assert() {
  if [ $? -eq 0 ]; then
    echo -n " ✓"
  else
    echo "\n    Fail"
    ANY_ERRORS=true
  fi
}

assertEqual() {
  if [ "$1" = "$2" ]; then
    echo -n " ✓"
  else
    echo "\n   $BOLD$RED Error:$RESET Expected \"$1\" to equal \"$2\""
    ANY_ERRORS=true
  fi
}

RUN_RESULT=""
RUN_EXIT=0

run_in() {
  RUN_RESULT=$(cd test/$1 && ../../t -n)
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

echo ""

if [ $ANY_ERRORS = true ]; then
  exit 1
fi
