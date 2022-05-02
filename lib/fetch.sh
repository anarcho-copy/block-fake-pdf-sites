#!/bin/bash
. config.conf || exit 1

# manualy fetch per rule/set

# turk-adlist:
echo "GET: https://raw.githubusercontent.com/bkrucarci/turk-adlist/master/hosts"
curl -s https://raw.githubusercontent.com/bkrucarci/turk-adlist/master/hosts | grep '127.0.0.1' | grep -v 'localhost' | sed 's/127.0.0.1 //g' > ${OTHERSOURCES}/turk-adlist

# ublacklist-tr:
echo "GET: https://raw.githubusercontent.com/dr-norton/ublacklist-tr/master/blocklist.txt"
curl -s https://raw.githubusercontent.com/dr-norton/ublacklist-tr/master/blocklist.txt | grep '\.' | sed 's/\///g' > ${OTHERSOURCES}/ublacklist-tr

# Turkish-Blocklist:
echo "GET: https://raw.githubusercontent.com/saurane/Turkish-Blocklist/master/Blocklist/plain.txt"
curl -s https://raw.githubusercontent.com/saurane/Turkish-Blocklist/master/Blocklist/plain.txt > ${OTHERSOURCES}/Turkish-Blocklist

# fake-github:
echo "GET: https://raw.githubusercontent.com/arosh/ublacklist-github-translation/master/uBlacklist.txt"
curl -s https://raw.githubusercontent.com/arosh/ublacklist-github-translation/master/uBlacklist.txt | sed 's/*:\/\///g; s/\/\*//g' > ${OTHERSOURCES}/fake-github

# fake-stack:
echo "GET: https://raw.githubusercontent.com/arosh/ublacklist-stackoverflow-translation/master/uBlacklist.txt"
curl -s https://raw.githubusercontent.com/arosh/ublacklist-stackoverflow-translation/master/uBlacklist.txt | sed 's/*:\/\///g; s/\/\*//g; s/\*\.//g' > ${OTHERSOURCES}/fake-stack

# pinterest
echo "GET: https://raw.githubusercontent.com/rjaus/ublacklist-pinterest/main/ublacklist-pinterest.txt"
curl -s https://raw.githubusercontent.com/rjaus/ublacklist-pinterest/main/ublacklist-pinterest.txt | grep 'pinterest\.' | sed 's/*:\/\///g; s/\/\*//g; s/\*\.//g' > ${OTHERSOURCES}/pinterest
