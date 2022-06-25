#!/bin/bash

sed 's/*:\/\///g; s/\/\*//g; s/www.//g' | sort -u

