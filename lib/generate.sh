#!/bin/bash
. config.conf || exit 1
mkdir -p ${TEMP}

# insert domains

# domain.tld it includes forcely denied ${HOSTS}.
cat ${TLD} | urlp --registered_domain | sort -u > ${TEMP}/domain
cat ${SLD} | urlp --registered_domain | sort -u >> ${TEMP}/domain
cat ${LOGINREQ} | urlp --registered_domain | sort -u >> ${TEMP}/domain

sed 's/\.wordpress\.com/\.files\.wordpress\.com/g' ${WORDPRESS} | sort -u >> ${TEMP}/domain
cat ${WORDPRESS} | sort -u >> ${TEMP}/domain
cat ${SERVICE} | sort -u >> ${TEMP}/domain

# include sources
if [[ "${include_other_sources}" == "true" ]]; then
	find ${OTHERSOURCES} -type f -not -name 'etherpad' -exec cat {} \; | urlp --registered_domain |sort -u >> ${TEMP}/domain
fi

# include etherpad
if [[ "${include_etherpad}" == "true" ]]; then
	cat ${OTHERSOURCES}/etherpad | sort -u >> ${TEMP}/domain
fi

# parse domain option
case ${1} in
	--all|-a|all)
		cat ${ALLOW} | grep "\." | sort -u >> ${TEMP}/domain
		cat ${STORE} | grep "\." | sort -u >> ${TEMP}/domain
	;;
esac

#VARIABLES
TOTAL_LINES=$(cat ${TEMP}/domain | wc -l)
DATE=$(date -u)
VERSION=$(date "+%Y%m%d%H%M%S" -d "$DATE")


# GENERATE UBLACKLIST
while IFS= read -r DOMAIN; do
	echo "*://${DOMAIN}/*"
done < ${TEMP}/domain | sort -u > ${UBLACKLIST}


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
done < ${TEMP}/domain | sort -u >> ${DNSMASQ}


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
done < ${TEMP}/domain | sort -u >> ${HOSTS}


# GENERATE PURE DOMAIN LIST
cat ${TEMP}/domain | sort -u > ${RAW}
