#!/bin/bash
. config.conf || exit 1

QUERY="$(cat ${SEACHTEST} | shuf -n1)"

while getopts ":gip:q:" opt; do
  case ${opt} in
     g) make all &>/dev/null ;;
     i) _ARG_1="-j" ;;
     p) _ARG_2="-p ${OPTARG}" ;;
     q) QUERY="${OPTARG}" ;;
     :) echo "Missing option argument for -${OPTARG}" ; exit 1 ;;
  esac
done

set -x
lib/google_url_extractor.py "${QUERY}" ${_ARG_1} ${_ARG_2}
