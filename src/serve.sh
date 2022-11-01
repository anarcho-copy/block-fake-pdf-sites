#!/bin/bash
# required function get_port()
# This script provides temp web server for testing.

# print usage info
usage() {
        echo "Usage: ${BASH_SOURCE[0]} -c make.config"
        exit 1
} ; if [[ "$#" -lt 1 ]]; then usage; fi

# parse options
while getopts ":c:" opt; do
    case "${opt}" in
        c) . "${OPTARG}" ;;     # make.config
        :) echo "Error: -${OPTARG} requires an argument." ; usage ;;
        *) usage ;;
    esac
done

if [[ -x "$(command -v python3.10)" ]]; then
	python3.10 -m http.server --directory "${BUILD_PATH}" --bind ${TEMP_SERVER_BIND} ${TEMP_SERVER_PORT}
else
	cd "${BUILD_PATH}"
	python3 -m http.server --bind ${TEMP_SERVER_BIND} ${TEMP_SERVER_PORT}
fi
