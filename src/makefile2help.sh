#!/bin/bash

targets="$(make -rpn | sed -n -e '/^$/ { n ; /^[^ .#][^ ]*:/ { s/:.*$// ; p ; } ; }' | grep -v "\-\-" | grep -v "^/" | sort -u)"

while IFS= read -r target; do
	targethelp="$(cat ".config/makehelp/${target}" 2>/dev/null )"
	echo "+${target} +${targethelp}"
done <<< "${targets}" | column -t -s '+'

exit 0
