#!/bin/bash

[ -f /etc/hosts.local ] || {
	cp /etc/hosts /etc/hosts.local
	mkdir -p /etc/hosts.d/
}

case ${1} in
    0|--disable) cat /etc/hosts.local > /etc/hosts ;;
    1|--enable) cat /etc/hosts.local > /etc/hosts ; cat /etc/hosts.d/* >> /etc/hosts  ;;
esac

