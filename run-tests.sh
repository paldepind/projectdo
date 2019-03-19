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

# Colors
RED=`tput setaf 1`
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

if [ $ANY_ERRORS = true ]; then
  exit 1
fi
