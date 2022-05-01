#!/bin/bash

. config.conf || exit 1
mkdir -p ${TEMP}

# insert domains

# domain.tld it includes forcely denied ${HOSTS}.
cat ${TLD} | urlp --registered_domain | uniq > ${TEMP}/domain
cat ${SLD} | urlp --registered_domain | uniq >> ${TEMP}/domain
cat ${LOGINREQ} | urlp --registered_domain | uniq >> ${TEMP}/domain

sed 's/\.wordpress\.com/\.files\.wordpress\.com/g' ${WORDPRESS} | uniq >> ${TEMP}/domain
cat ${WORDPRESS} | uniq >> ${TEMP}/domain
cat ${SERVICE} | uniq >> ${TEMP}/domain

# parse domain option
case ${1} in
	--all|-a|all)
		cat ${ALLOW} | grep "\." | uniq >> ${TEMP}/domain
		cat ${STORE} | grep "\." | uniq >> ${TEMP}/domain
	;;
esac

#VARIABLES
TOTAL_LINES=$(cat ${TEMP}/domain | wc -l)
DATE=$(date -u)
VERSION=$(date "+%Y%m%d%H%M%S" -d "$DATE")


# GENERATE UBLACKLIST
while IFS= read -r DOMAIN; do
	echo "/${DOMAIN}/"
done < ${TEMP}/domain | sort > ${UBLACKLIST}


# GENREATE DNSMASQ
cat > ${DNSMASQ} <<EOT
#TITLE=${TITLE}
#VER=${VERSION}
#URL=${REPO}
#FILE=${RAW_SOURCE}/${DNSMASQ}
#TOTAL_LINES=${TOTAL_LINES}
EOT
while IFS= read -r DOMAIN; do
	echo "address=/${DOMAIN}/"
done < ${TEMP}/domain | sort >> ${DNSMASQ}


# GENERATE LOCAL DNS
cat > ${HOSTS} <<EOT
###
#
# Name        : ${TITLE}
# Version     : ${VERSION}
# Date        : ${DATE}
#
# Repo        : ${REPO}
# File        : ${RAW_SOURCE}/${HOSTS}
# Total lines : ${TOTAL_LINES}
#
###

0.0.0.0 0.0.0.0

EOT
while IFS= read -r DOMAIN; do
        echo "0.0.0.0 ${DOMAIN}"
	echo "0.0.0.0 www.${DOMAIN}"	#force add www subdomain
done < ${TEMP}/domain | sort >> ${HOSTS}


# GENERATE PURE DOMAIN LIST
cat ${TEMP}/domain | sort > ${RAW}
