#!/bin/bash
. make.config || exit 1
mkdir -p ${ETHERPAD_SOURCE_DIR}

# manualy fetch per rule/set

# https://paper.komun.org/p/block-fake-pdf-sites/export/txt:
echo "GET: https://paper.komun.org/p/block-fake-pdf-sites/export/txt"
curl -s curl https://paper.komun.org/p/block-fake-pdf-sites/export/txt | grep '\.' | sed 's/\///g' | sed -r 's/\s+//g' > ${ETHERPAD_SOURCE}
