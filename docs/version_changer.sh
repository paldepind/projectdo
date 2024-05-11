#!/bin/sh
set -e

# Store current dir
old_dir=$(pwd)

# Get docs directoy the POSIX way
DOCS_PATH="$0"
if [ ! -e "$DOCS_PATH" ]; then
  case $DOCS_PATH in
    (*/*) exit 1;;
    (*) DOCS_PATH=$(command -v -- "$DOCS_PATH") || exit;;
  esac
fi
docs_dir=$(
  cd -P -- "$(dirname -- "$DOCS_PATH")" && pwd -P
) || exit

# Go into docs dir
cd "$docs_dir"
cd ..

# Define other dirs
project_dir=$(pwd)
man_dir="${project_dir}/man"

date=$(date '+%B %d, %Y')
version=$(sh -c "${project_dir}/./projectdo --version" | grep -Eo '[0-9]\.[0-9]\.[0-9]+')

printf '%s is the current projectdo version.\n' "$version"
printf "What version do you want to change it to?\n: "; read -r ver_choice

sed -i "s/date\:.*/date: $date/g" "${man_dir}/projectdo.1.md"

sed -i "s/VERSION=.*/VERSION=\"$ver_choice\"/" "${project_dir}/./projectdo"
printf 'Successfully updated version number to %s in projectdo.\n' "$ver_choice"

sed -i "s/footer\:.*/footer: projectdo $ver_choice/" "${man_dir}/projectdo.1.md"
printf 'Successfully updated version number to %s in projectdo.1.md\n' "$ver_choice"

printf "Do you want to generate new manpage?\n[Y/n]: "; read -r man_choice
if ! [ "$man_choice" = "n" ]; then
    make manpage
fi

# Go back to the dir where user was before
cd "$old_dir"

exit 0
