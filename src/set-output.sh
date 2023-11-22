#!/bin/bash

set -e

name="$1"
value="$2"
{
    echo "${name}<<EOF"
    echo "$value"
    echo 'EOF'
} >> "$GITHUB_OUTPUT"

#value="${value//'%'/'%25'}"
#value="${value//$'\n'/'%0A'}"
#value="${value//$'\r'/'%0D'}"
#echo "${name}=${value}" >> "$GITHUB_OUTPUT"
