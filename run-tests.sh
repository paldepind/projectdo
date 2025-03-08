#!/bin/sh

# Colors
RED=$(tput setaf 1)
BOLD=$(tput bold)
RESET=$(tput sgr0)

ANY_ERRORS=false

# Make sets this variable when we run it and can influence the test results.
# Since this script is run through `make`, we need to unset it.
unset MAKELEVEL

# Get the directory of the current script, in a POSIX compatible way
# https://stackoverflow.com/a/29835459
script_directory=$(CDPATH="$(cd -- "$(dirname -- "$0")")" && pwd -P)

# Set this variable to ensure top level Makefile doesn't affect the results.
export PROJECT_ROOT="${script_directory}/tests"

describe() {
  printf "\n%s%s%s" "$BOLD" "$1" "$RESET"
}

it() {
  printf "\n  %s" "$1"
}

assert() {
  if [ $RUN_EXIT -eq 0 ]; then
    printf " ✓"
  else
    printf "\n    Fail\n"
    ANY_ERRORS=true
  fi
}

assertFails() {
  if [ $RUN_EXIT -ne 0 ]; then
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
    printf "\n   %s%s Error:%s Expected \"%s\" to equal \"%s\"\n" "$BOLD" "$RED" "$RESET" "$1" "$2"
    ANY_ERRORS=true
  fi
}
RUN_EXIT=0

do_build_in() {
  RUN_RESULT=$(cd tests/"$1" && ../../projectdo -n build)
  RUN_EXIT=$?
}

do_run_in() {
  RUN_RESULT=$(cd tests/"$1" && ../../projectdo -n run)
  RUN_EXIT=$?
}

do_test_in() {
  RUN_RESULT=$(cd tests/"$1" && ../../projectdo -n test)
  RUN_EXIT=$?
}

do_print_tool_in() {
  RUN_RESULT=$(cd tests/"$1" && ../../projectdo -n tool)
  RUN_EXIT=$?
}

if describe "cargo"; then
  if it "can run build"; then
    do_build_in "cargo"; assert
    assertEqual "$RUN_RESULT" "cargo build"
  fi
  if it "can run run"; then
    do_run_in "cargo"; assert
    assertEqual "$RUN_RESULT" "cargo run"
  fi
  if it "can run test"; then
    do_test_in "cargo"; assert
    assertEqual "$RUN_RESULT" "cargo test"
  fi
  if it "can print tool"; then
    do_print_tool_in "cargo"; assert
    assertEqual "$RUN_RESULT" "cargo"
  fi
  if it "passes additional arguments to the tool"; then
    RUN_RESULT=$(cd tests/cargo && ../../projectdo -n build --release)
    assertEqual "$RUN_RESULT" "cargo build --release"
  fi
fi

if describe "stack"; then
  if it "can run build"; then
    do_build_in "stack"; assert
    assertEqual "$RUN_RESULT" "stack build"
  fi
  if it "can run run"; then
    do_run_in "stack"; assert
    assertEqual "$RUN_RESULT" "stack run"
  fi
  if it "can run test"; then
    do_test_in "stack"; assert
    assertEqual "$RUN_RESULT" "stack test"
  fi
  if it "can print tool"; then
    do_print_tool_in "stack"; assert
    assertEqual "$RUN_RESULT" "stack"
  fi
fi

if describe "npm / yarn / pnpm"; then
  if it "can run npm build if package.json with build script"; then
    do_build_in "npm"; assert
    assertEqual "$RUN_RESULT" "npm run build"
  fi
  if it "can run npm start if package.json with start script"; then
    do_run_in "npm"; assert
    assertEqual "$RUN_RESULT" "npm start"
  fi
  if it "can run npm test if package.json with test script"; then
    do_test_in "npm"; assert
    assertEqual "$RUN_RESULT" "npm test"
  fi
  if it "uses yarn if yarn.lock is present"; then
    do_test_in "yarn"; assert
    assertEqual "$RUN_RESULT" "yarn test"
  fi
  if it "uses pnpm if pnpm-lock.yaml is present"; then
    do_test_in "pnpm"; assert
    assertEqual "$RUN_RESULT" "pnpm test"
  fi
  if it "can run pnpm build if package.json with build script"; then
    do_build_in "pnpm"; assert
    assertEqual "$RUN_RESULT" "pnpm run build"
  fi
  if it "can run pnpm start if package.json with start script"; then
    do_run_in "pnpm"; assert
    assertEqual "$RUN_RESULT" "pnpm start"
  fi
  if it "can run pnpm test if package.json with test script"; then
    do_test_in "pnpm"; assert
    assertEqual "$RUN_RESULT" "pnpm test"
  fi
  if it "does not use npm if package.json contains no test script"; then
    do_test_in "npm-without-test"; assert
    assertEqual "$RUN_RESULT" "make test"
  fi
  if it "can print tool"; then
    do_print_tool_in "npm"; assert
    assertEqual "$RUN_RESULT" "npm"
    do_print_tool_in "yarn"; assert
    assertEqual "$RUN_RESULT" "yarn"
    do_print_tool_in "pnpm"; assert
    assertEqual "$RUN_RESULT" "pnpm"
  fi
fi

if describe "just"; then
  if it "finds test target"; then
    do_test_in "just"; assert
    assertEqual "$RUN_RESULT" "just test"
  fi
  if it "finds build target"; then
    do_build_in "just"; assert
    assertEqual "$RUN_RESULT" "just build"
  fi
  if it "finds run target"; then
    do_run_in "just"; assert
    assertEqual "$RUN_RESULT" "just run"
  fi
  if it "can print tool"; then
    do_print_tool_in "just"; assert
    assertEqual "$RUN_RESULT" "just"
  fi
fi

if describe "make"; then
  if it "finds check target"; then
    do_test_in "make-check"; assert
    assertEqual "$RUN_RESULT" "make check"
  fi
  if it "ignores file named check"; then
    do_test_in "make-check-with-check-file"; assertFails
    assertEqual "$RUN_RESULT" "No way to test found :'("
  fi
  if it "finds check target if both target and file named check"; then
    do_test_in "make-check-with-check-file-and-target"; assert
    assertEqual "$RUN_RESULT" "make check"
  fi
fi

if describe "go"; then
  if it "finds check target in magefile"; then
    do_test_in "mage"; assert
    assertEqual "$RUN_RESULT" "mage check"
  fi
fi

if describe "python"; then
  if it "can build with poetry"; then
    do_build_in "poetry"; assert
    assertEqual "$RUN_RESULT" "poetry build"
  fi
  if it "runs pytest with poetry"; then
    do_test_in "poetry"; assert
    assertEqual "$RUN_RESULT" "poetry run pytest"
  fi
fi

if describe "latex"; then
  if it "can build with tectonic"; then
    do_build_in "tectonic"; assert
    assertEqual "$RUN_RESULT" "tectonic -X build"
  fi
fi

if describe "meson"; then
  if it "can build with meson"; then
    do_build_in "meson"; assert
    assertEqual "$RUN_RESULT" "meson compile"
  fi
  if it "can test with meson"; then
    do_test_in "meson"; assert
    assertEqual "$RUN_RESULT" "meson test"
  fi
fi

if describe "dotnet csproj"; then
  if it "can build with dotnet"; then
    do_build_in "dotnet-csproj"; assert
    assertEqual "$RUN_RESULT" "dotnet build"
  fi
  if it "can run with dotnet"; then
    do_run_in "dotnet-csproj"; assert
    assertEqual "$RUN_RESULT" "dotnet run"
  fi
  if it "can test with dotnet"; then
    do_test_in "dotnet-csproj"; assert
    assertEqual "$RUN_RESULT" "dotnet test"
  fi
fi

if describe "dotnet fsproj"; then
  if it "can build with dotnet"; then
    do_build_in "dotnet-fsproj"; assert
    assertEqual "$RUN_RESULT" "dotnet build"
  fi
  if it "can run with dotnet"; then
    do_run_in "dotnet-fsproj"; assert
    assertEqual "$RUN_RESULT" "dotnet run"
  fi
  if it "can test with dotnet"; then
    do_test_in "dotnet-fsproj"; assert
    assertEqual "$RUN_RESULT" "dotnet test"
  fi
fi

if describe "dotnet sln"; then
  if it "can build with dotnet"; then
    do_build_in "dotnet-sln"; assert
    assertEqual "$RUN_RESULT" "dotnet build"
  fi
  if it "can run with dotnet"; then
    do_run_in "dotnet-sln"; assert
    assertEqual "$RUN_RESULT" "dotnet run"
  fi
  if it "can test with dotnet"; then
    do_test_in "dotnet-sln"; assert
    assertEqual "$RUN_RESULT" "dotnet test"
  fi
fi

if describe "build script"; then
  if it "can build with build script"; then
    do_build_in "build_script"; assert
    assertEqual "$RUN_RESULT" "sh -c build.sh"
  fi
fi

echo ""

if [ $ANY_ERRORS = true ]; then
  exit 1
fi
