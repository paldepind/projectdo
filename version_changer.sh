#!/bin/sh
set -e

date=$(date '+%B %d, %Y')
version=$(sh -c "./projectdo --version" | grep -Eo '[0-9]\.[0-9]\.[0-9]+')

sed -i "s/date\:.*/date: $date/g" man/projectdo.1.md

printf '%s is the current projectdo version.\n' "$version"
printf "What version do you want to change it to?\n: "; read -r ver_choice

sed -i "s/VERSION=.*/VERSION=\"$ver_choice\"/" ./projectdo
printf 'Successfully updated version number to %s in projectdo.\n' "$ver_choice"

sed -i "s/footer\:.*/footer: projectdo $ver_choice/" man/projectdo.1.md
printf 'Successfully updated version number to %s in projectdo.1.md\n' "$ver_choice"

printf "Do you want to generate new manpage?\n[Y/n]: "; read -r man_choice
if ! [ "$man_choice" = "n" ]; then
    make manpage
fi

exit 0

