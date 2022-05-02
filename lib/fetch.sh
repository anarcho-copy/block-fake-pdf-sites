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
