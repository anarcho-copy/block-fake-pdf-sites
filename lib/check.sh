#!/bin/bash

while IFS= read -r command; do
        if command -v "${command}" &>/dev/null; then
                echo "checking for ${command}... yes"
        else
            	echo "checking for ${command}... no"
                requirements="${requirements} ${command}"
                install="true"
        fi
done < <(grep -o '^[^#]*' INSTALL)

if [[ "${install}" == "true" ]]; then
        echo -e "\nplease install:"
        echo "   ${requirements}"
fi
