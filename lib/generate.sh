#!/bin/bash
. config.conf || exit 1
mkdir -p ${TEMP}

# insert domains
cat ${TLD} > ${TEMP}/tld
cat ${TLD} | urlp --registered_domain >> ${TEMP}/tld
cat ${TEMP}/tld | sort -u > ${TEMP}/domain

cat ${SLD} > ${TEMP}/sld
cat ${SLD} | urlp --registered_domain >> ${TEMP}/sld
cat ${TEMP}/sld | sort -u >> ${TEMP}/domain

cat ${LOGINREQ} > ${TEMP}/login_req
cat ${LOGINREQ} | urlp --registered_domain >> ${TEMP}/login_req
cat ${TEMP}/login_req | sort -u >> ${TEMP}/domain

# blocked services
cat ${SERVICE} | sort -u >> ${TEMP}/domain

# wordpress based domains
sed 's/\.wordpress\.com/\.files\.wordpress\.com/g' ${WORDPRESS} | sort -u >> ${TEMP}/domain
cat ${WORDPRESS} | sort -u >> ${TEMP}/domain

# blogspot based domains
cat ${BLOGSPOT} | sort -u >> ${TEMP}/domain

# netlify based domains
cat ${NETLIFY} | sort -u >> ${TEMP}/domain

# include sources
if [[ "${include_other_sources}" == "true" ]]; then
	find ${OTHERSOURCES} -type f -not -name 'etherpad' -exec cat {} \; | sed 's/www\.//g' > ${TEMP}/other_sources
	find ${OTHERSOURCES} -type f -not -name 'etherpad' -exec cat {} \; | urlp --registered_domain  >> ${TEMP}/other_sources
	sort -u ${TEMP}/other_sources | sed -r '/^\s*$/d' >> ${TEMP}/domain
fi

# include etherpad
if [[ "${include_etherpad}" == "true" ]]; then
	cat ${OTHERSOURCES}/etherpad > ${TEMP}/etherpad
	cat ${OTHERSOURCES}/etherpad | urlp --registered_domain >> ${TEMP}/etherpad
	cat ${TEMP}/etherpad | sort -u >> ${TEMP}/domain
fi

# parse domain option
case ${1} in
	--all|-a|all)
		cat ${ALLOW} > ${TEMP}/allow
		cat ${ALLOW} | urlp --registered_domain >> ${TEMP}/allow
		cat ${TEMP}/allow | grep "\." | sort -u >> ${TEMP}/domain

		cat ${STORE} > ${TEMP}/store
		cat ${STORE} | urlp --registered_domain >> ${TEMP}/store
		cat ${TEMP}/store | grep "\." | sort -u >> ${TEMP}/domain
	;;
esac

#VARIABLES
TOTAL_LINES=$(cat ${TEMP}/domain | wc -l)
DATE=$(date -u)
VERSION=$(date "+%Y%m%d%H%M%S" -d "$DATE")


# GENERATE UBLACKLIST
cat > ${UBLACKLIST} <<EOT
# Name        : ${TITLE}
# Version     : ${VERSION}
# Date        : ${DATE}
# Repo        : ${REPO}
# File        : ${RAW_SOURCE}/${UBLACKLIST}
# Total lines : ${TOTAL_LINES}

EOT
while IFS= read -r DOMAIN; do
	echo "/${DOMAIN}/"
done < ${TEMP}/domain | sort -u >> ${UBLACKLIST}


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
done < ${TEMP}/domain | sed "s/www.//g" | sort -u >> ${DNSMASQ}


# GENERATE LOCAL DNS
cat > ${HOSTS} <<EOT
# Name        : ${TITLE}
# Version     : ${VERSION}
# Date        : ${DATE}
# Repo        : ${REPO}
# File        : ${RAW_SOURCE}/${HOSTS}
# Total lines : ${TOTAL_LINES}

0.0.0.0 0.0.0.0
EOT
while IFS= read -r DOMAIN; do
        echo "0.0.0.0 ${DOMAIN}"
	echo "0.0.0.0 www.${DOMAIN}"	#force add www subdomain
done < ${TEMP}/domain | sed "s/www.www./www./g" | sort -u >> ${HOSTS}


# GENERATE PURE DOMAIN LIST
cat ${TEMP}/domain | sort -u > ${RAW}
