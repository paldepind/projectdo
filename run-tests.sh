#!/bin/sh

# Colors
BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`
BOLD=`tput bold`
RESET=`tput sgr0`

ANY_ERRORS=false

describe() {
  echo -n $BOLD$1$RESET
}

it() {
  echo -n "\n  $1"
}

assert() {
  if [ $? -eq 0 ]; then
    echo -n " ✓"
  else
    echo "\n    Fail"
  fi
}

assertEqual() {
  if [ "$1" = "$2" ]; then
    echo -n " ✓"
  else
    echo "\n   $BOLD$RED Error:$RESET Expected \"$1\" to equal \"$2\""
  fi
}

RUN_RESULT=""
RUN_EXIT=0

run_in() {
  RUN_RESULT=$(cd test/$1 && ../../testerything -n)
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
fi

echo ""
