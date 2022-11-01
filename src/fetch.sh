#!/bin/bash
. make.config || exit 1
mkdir -p ${OTHER_HOSTS_SOURCES} ${OTHER_UBLACKLIST_SOURCES}

# manualy fetch per rule/set

# turk-adlist:
echo "GET: https://raw.githubusercontent.com/bkrucarci/turk-adlist/master/hosts"
curl -s https://raw.githubusercontent.com/bkrucarci/turk-adlist/master/hosts | grep '127.0.0.1' | grep -v 'localhost' | sed 's/127.0.0.1 //g' > ${OTHER_HOSTS_SOURCES}/turk-adlist

# ublacklist-tr:
echo "GET: https://raw.githubusercontent.com/dr-norton/ublacklist-tr/master/blocklist.txt"
curl -s https://raw.githubusercontent.com/dr-norton/ublacklist-tr/master/blocklist.txt | grep '\.' | sed 's/\///g' > ${OTHER_UBLACKLIST_SOURCES}/ublacklist-tr

# Turkish-Blocklist:
echo "GET: https://raw.githubusercontent.com/saurane/Turkish-Blocklist/master/Blocklist/plain.txt"
curl -s https://raw.githubusercontent.com/saurane/Turkish-Blocklist/master/Blocklist/plain.txt > ${OTHER_HOSTS_SOURCES}/Turkish-Blocklist

# fake-github:
echo "GET: https://raw.githubusercontent.com/arosh/ublacklist-github-translation/master/uBlacklist.txt"
curl -s https://raw.githubusercontent.com/arosh/ublacklist-github-translation/master/uBlacklist.txt | sed 's/*:\/\///g; s/\/\*//g' > ${OTHER_UBLACKLIST_SOURCES}/fake-github

# fake-stack:
echo "GET: https://raw.githubusercontent.com/arosh/ublacklist-stackoverflow-translation/master/uBlacklist.txt"
curl -s https://raw.githubusercontent.com/arosh/ublacklist-stackoverflow-translation/master/uBlacklist.txt | sed 's/*:\/\///g; s/\/\*//g; s/\*\.//g' > ${OTHER_UBLACKLIST_SOURCES}/fake-stack

# pinterest:
echo "GET: https://raw.githubusercontent.com/rjaus/ublacklist-pinterest/main/ublacklist-pinterest.txt"
curl -s https://raw.githubusercontent.com/rjaus/ublacklist-pinterest/main/ublacklist-pinterest.txt | grep 'pinterest\.' | sed 's/*:\/\///g; s/\/\*//g; s/\*\.//g' > ${OTHER_UBLACKLIST_SOURCES}/pinterest

# aliexpress-fake-sites:
echo "GET: https://raw.githubusercontent.com/franga2000/aliexpress-fake-sites/main/domains_uBlacklist.txt"
curl -s https://raw.githubusercontent.com/franga2000/aliexpress-fake-sites/main/domains_uBlacklist.txt | sed 's/*:\/\///g; s/\/\*//g' > ${OTHER_UBLACKLIST_SOURCES}/aliexpress-fake-sites

# TurkishAdblockList
echo "GET: https://raw.githubusercontent.com/huzunluartemis/TurkishAdblockList/main/src/HostsList.txt"
curl -s https://raw.githubusercontent.com/huzunluartemis/TurkishAdblockList/main/src/HostsList.txt | grep '127.0.0.1' | grep -v 'localhost' | sed 's/127.0.0.1 //g' > ${OTHER_HOSTS_SOURCES}/TurkishAdblockList

# remove CRLF line terminators
dos2unix ${EXTERNAL_DIR}/*/*
mac2unix ${EXTERNAL_DIR}/*/*
