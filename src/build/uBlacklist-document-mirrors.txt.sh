#!/bin/bash
. make.config || exit 1
. list/make.config || exit 1

mkdir -p ${TEMP}
rm -rf ${TEMP}/*

# insert domains
faup -o json ${DOCUMENT_MIRRORS} | jq -r .domain | sort -u > ${TEMP}/document-mirrors.dat
# check domains
if cat ${TEMP}/document-mirrors.dat | psl --load-psl-file list/${TLD_FILE}.dafsa | grep ': 1'; then
	echo "TLD found! Please check it.."
	exit 1
fi
# set information variables
UBLACKLIST_DOCUMENT_MIRRORS_TOTAL_LINES=$(cat ${TEMP}/document-mirrors.dat | wc -l)
# GENERATE UBLACKLIST
cat > ${UBLACKLIST_DOCUMENT_MIRRORS} << EOT
# Name        : ${UBLACKLIST_DOCUMENT_MIRRORS_TITLE}
# Version     : ${VERSION}
# Date        : ${DATE}
# Repo        : ${REPO}
# File        : ${RAW_SOURCE}/${UBLACKLIST_DOCUMENT_MIRRORS}
# Total lines : ${UBLACKLIST_DOCUMENT_MIRRORS_TOTAL_LINES}

EOT
while IFS= read -r DOMAIN; do
        echo "*://*.${DOMAIN}/*"
done < ${TEMP}/document-mirrors.dat >> ${UBLACKLIST_DOCUMENT_MIRRORS}
