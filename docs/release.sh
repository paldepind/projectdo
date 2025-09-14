#!/bin/sh
set -e

# Exit if the git working directory is dirty
if [ -n "$(git status --porcelain)" ]; then
	echo "Git working directory is dirty."
	echo ""
	echo "Please commit or stash your changes before creating a release."
	exit 1
fi

# Store current dir
old_dir=$(pwd)

# Get docs directoy the POSIX way
DOCS_PATH="$0"
if [ ! -e "$DOCS_PATH" ]; then
	case $DOCS_PATH in
	*/*) exit 1 ;;
	*) DOCS_PATH=$(command -v -- "$DOCS_PATH") || exit ;;
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
printf "What version do you want to change it to?\n: "
read -r ver_choice

ex -sc "%s/date\:.*/date: $date/g" -c 'x' "${man_dir}/projectdo.1.md"

ex -sc "%s/VERSION=.*/VERSION=\"$ver_choice\"/" -c 'x' "${project_dir}/./projectdo"
printf 'Successfully updated version number to %s in projectdo.\n' "$ver_choice"

ex -sc "%s/\"version\": \"[^\"]*\"/\"version\": \"$ver_choice\"/g" -c 'x' "${project_dir}/package.json"
printf 'Successfully updated version number to %s in package.json.\n' "$ver_choice"

ex -sc "%s/footer\:.*/footer: projectdo $ver_choice/" -c 'x' "${man_dir}/projectdo.1.md"
printf 'Successfully updated version number to %s in projectdo.1.md\n' "$ver_choice"

printf "Do you want to generate new manpage?\n[Y/n]: "
read -r man_choice
if ! [ "$man_choice" = "n" ]; then
	make manpage
fi

printf "Creating a git commit and tag for version %s.\n" "$ver_choice"
git add -u
git commit -m "Release version $ver_choice"
git tag "v$ver_choice"

printf "Check that everything looks ok, then push with:\n"
printf "  git push origin\n"
printf "  git push origin tag v%s\n" "$ver_choice"

# Go back to the dir where user was before
cd "$old_dir"

exit 0
