#!/bin/bash
. config.conf || exit 1
mkdir -p ${TEMP}
rm -rf ${TEMP}/*
touch ${TEMP}/ubased ${TEMP}/hbased

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

# include allowed domains
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

# include sources
if [[ "${include_other_sources}" == "true" ]]; then
        # include host sources
        find ${HBASED} -type f -exec cat {} \; | sed 's/www\.//g' > ${TEMP}/.hbased
        find ${HBASED} -type f -exec cat {} \; | urlp --registered_domain  >> ${TEMP}/.hbased
        sort -u ${TEMP}/.hbased | sed -r '/^\s*$/d' > ${TEMP}/hbased

        # include ublacklist sources
        find ${UBASED} -type f -not -name 'etherpad' -exec cat {} \; | sed 's/www\.//g' > ${TEMP}/.ubased
        find ${UBASED} -type f -not -name 'etherpad' -exec cat {} \; | urlp --registered_domain  >> ${TEMP}/.ubased
        sort -u ${TEMP}/.ubased | sed -r '/^\s*$/d' > ${TEMP}/ubased
fi

# include etherpad
if [[ "${include_etherpad}" == "true" ]]; then
        cat ${UBASED}/etherpad > ${TEMP}/etherpad
        cat ${UBASED}/etherpad | urlp --registered_domain >> ${TEMP}/etherpad
        cat ${TEMP}/etherpad | sort -u >> ${TEMP}/ubased
fi

# last write step
sort -u ${TEMP}/domain ${TEMP}/ubased | sed -r '/^\s*$/d' > ${TEMP}/ubaseddomain
sort -u ${TEMP}/domain ${TEMP}/ubased ${TEMP}/hbased | sed -r '/^\s*$/d' > ${TEMP}/lastdomain


# set info variables
TOTAL_LINES=$(cat ${TEMP}/lastdomain | wc -l)
TOTAL_LINES_UBASED=$(cat ${TEMP}/ubaseddomain | wc -l)
DATE=$(date -u)
VERSION=$(date "+%Y%m%d%H%M%S" -d "$DATE")


# GENERATE UBLACKLIST
cat > ${UBLACKLIST} <<EOT
# Name        : ${TITLE}
# Version     : ${VERSION}
# Date        : ${DATE}
# Repo        : ${REPO}
# File        : ${RAW_SOURCE}/${UBLACKLIST}
# Total lines : ${TOTAL_LINES_UBASED}

EOT
while IFS= read -r DOMAIN; do
	echo "/${DOMAIN}/"
done < ${TEMP}/ubaseddomain | sort -u >> ${UBLACKLIST}


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
done < ${TEMP}/lastdomain | sed "s/www.//g" | sort -u >> ${DNSMASQ}


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
done < ${TEMP}/lastdomain | sed "s/www.www./www./g" | sort -u >> ${HOSTS}


# GENERATE PURE DOMAIN LIST
cat ${TEMP}/lastdomain | sort -u > ${RAW}
