#!/bin/bash

# print usage info
usage() {
	echo "Usage: ${BASH_SOURCE[0]} <file>"
        exit 1
} ; if [[ "$#" -lt 1 ]]; then usage; fi

# check options
if [[ ! -f "${1}" ]]; then
	echo "${1} does not exist"
	exit 1
fi

# main
sed 's/*:\/\///g; s/\/\*//g; s/www.//g' "${1}" | sort -u > "${1}.list"
{ sleep 10; rm -f "${1}"; } &
