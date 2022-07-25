#!/bin/bash
. config.conf || exit 1
mkdir -p ${UBASED}

# manualy fetch per rule/set

# https://paper.komun.org/p/block-fake-pdf-sites/export/txt:
echo "GET: https://paper.komun.org/p/block-fake-pdf-sites/export/txt"
curl -s curl https://paper.komun.org/p/block-fake-pdf-sites/export/txt | grep '\.' | sed 's/\///g' > ${UBASED}/etherpad
