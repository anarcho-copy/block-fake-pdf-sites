#!/bin/bash
. make.config || exit 1
. list/make.config || exit 1

mkdir -p ${TEMP}
rm -rf ${TEMP}/*
touch ${TEMP}/ubased ${TEMP}/hbased

# insert domains
faup -o json ${BLACKLIST_DOMAINS} | jq -r .domain > ${TEMP}/domain
faup -o json ${WASTE_LOGIN_REQUIRED} | jq -r .domain >> ${TEMP}/domain

# generate .files.wordpress.com
faup -o json ${BLACKLIST_DOMAINS}| jq -r .domain | grep '\.wordpress\.com' | sed 's/.wordpress.com/.files.wordpress.com/g' >> ${TEMP}/domain

# include whitelist domains
case ${1} in
	--all|-a|all)
		faup -o json ${WHITELIST_DOMAINS} | jq -r .domain >> ${TEMP}/domain
		faup -o json ${WHITELIST_TURKISH_BOOKSTORES} | jq -r .domain >> ${TEMP}/domain
esac

# include sources
if [[ "${include_other_sources}" == "true" ]]; then
        # include host sources
        find ${OTHER_HOSTS_SOURCES} -type f -exec cat {} \; | faup -o json | jq -r .domain >> ${TEMP}/hbased

        # include ublacklist sources
	find ${OTHER_UBLACKLIST_SOURCES} -type f -exec cat {} \; | faup -o json | jq -r .domain >> ${TEMP}/ubased
fi

# include etherpad
if [[ "${include_etherpad}" == "true" ]]; then
	faup -o json ${ETHERPAD_SOURCE} | jq -r .domain >> ${TEMP}/ubased
fi

# include paths
cat ${BLACKLIST_PATHS} >> ${TEMP}/ubased

# last write step
sort -u ${TEMP}/domain ${TEMP}/ubased > ${TEMP}/ublacklist.dat
sort -u ${TEMP}/domain ${TEMP}/ubased ${TEMP}/hbased > ${TEMP}/all.dat

# check domains
if cat ${TEMP}/all.dat | psl --load-psl-file list/${TLD_FILE}.dafsa | grep ': 1'; then
	echo "TLD found! Please check it.."
	exit 1
fi

# set information variables
TOTAL_LINES=$(cat ${TEMP}/all.dat | wc -l)
TOTAL_LINES_UBASED=$(cat ${TEMP}/ublacklist.dat | wc -l)
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
	echo "*://*.${DOMAIN}/*"
done < ${TEMP}/ublacklist.dat | sort -u >> ${UBLACKLIST}


# GENREATE DNSMASQ
cat > ${DNSMASQ} <<EOT
#TITLE=${TITLE}
#VER=${VERSION}
#URL=${REPO}
#FILE=${RAW_SOURCE}/${DNSMASQ}
#TOTAL_LINES=${TOTAL_LINES}

EOT
while IFS= read -r DOMAIN; do
	echo "address=/${DOMAIN}/${BLOCK_IP}"
done < ${TEMP}/all.dat | sed "s/www.//g" | sort -u >> ${DNSMASQ}


# GENERATE LOCAL DNS
cat > ${HOSTS} <<EOT
# Name        : ${TITLE}
# Version     : ${VERSION}
# Date        : ${DATE}
# Repo        : ${REPO}
# File        : ${RAW_SOURCE}/${HOSTS}
# Total lines : ${TOTAL_LINES}

EOT
while IFS= read -r DOMAIN; do
        echo "${BLOCK_IP} ${DOMAIN}"
	echo "${BLOCK_IP} www.${DOMAIN}"	#force add www subdomain
done < ${TEMP}/all.dat | sed "s/www.www./www./g" | sort -u >> ${HOSTS}


# GENERATE PURE DOMAIN LIST
cat ${TEMP}/all.dat | sort -u > ${RAW}
